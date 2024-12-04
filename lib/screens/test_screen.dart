// This file is part of InjuredPixels (https://www.aurelitec.com/injuredpixels/).
// Copyright 2016-2024 Aurelitec. All rights reserved.
// See the LICENSE file in the project root for license information.
// @author TechAurelian <dev@techaurelian.com> (https://techaurelian.com)

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/preferences.dart' as prefs;
import '../common/strings.dart' as strings;
import '../common/urls.dart' as urls;
import '../models/test_color.dart';
import '../utils/utils.dart' as utils;
import '../utils/web_utils.dart' as web_utils;
import '../widgets/on_screen_tip.dart';
import '../widgets/test_control_panel.dart';

/// The home screen of the app.
///
/// It's a test screen that shows a full-screen color to let the user inspect the display for
/// defects, allows the user to cycle through a list of test colors, and to enter/exit an inspection
/// mode that hides all UI elements except the color screen.
class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  /// Whether a mouse is connected. Used to update the tip text terminology ("click" or "tap").
  bool _mouseIsConnected = false;

  /// The focus node for the body of the screen, used to capture key events.
  late final FocusNode _bodyFocusNode;

  /// Whether we are in inspection mode, which hides all UI elements except the color screen.
  bool _inInspectionMode = false;

  /// Whether to show the inspection mode tip.
  bool _showInspectionModeTip = true;

  @override
  void initState() {
    super.initState();
    _bodyFocusNode = FocusNode();

    // Disable the context menu on the web platform to be able to capture long press events
    if (kIsWeb) BrowserContextMenu.disableContextMenu();
  }

  @override
  void dispose() {
    _bodyFocusNode.dispose();
    if (kIsWeb) BrowserContextMenu.enableContextMenu();
    super.dispose();
  }

  /// Handles the color button press event by updating the selected color index.
  void _onColorButtonPressed(int index) {
    setState(() => prefs.testColorIndex.value = index);
  }

  /// Selects the next color in the list, wrapping around to the first color if necessary.
  void _nextColor() {
    setState(() {
      prefs.testColorIndex.value = prefs.testColorIndex.value == TestColor.values.length - 1
          ? 0
          : prefs.testColorIndex.value + 1;
    });
  }

  /// Selects the previous color in the list, wrapping around to the last color if necessary.
  void _previousColor() {
    setState(() {
      prefs.testColorIndex.value = prefs.testColorIndex.value == 0
          ? TestColor.values.length - 1
          : prefs.testColorIndex.value - 1;
    });
  }

  /// Handles the key events for changing colors and toggling the inspection mode.
  void _handleKeys(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return;
    }

    switch (event.logicalKey) {
      // Go to the previous color when the left key is pressed
      case LogicalKeyboardKey.arrowLeft:
        _previousColor();
        break;
      // Go to the next color when the right key is pressed
      case LogicalKeyboardKey.arrowRight:
        _nextColor();
        break;
      // Toggle the inspection mode when the space key is pressed
      case LogicalKeyboardKey.space:
        _toggleInspectionMode();
        break;
    }
  }

  /// Toggles the inspection mode, which hides all UI elements and goes fullscreen.
  void _toggleInspectionMode() {
    if (_inInspectionMode) {
      // Update the mouse connection status to update the tip text terminology
      _mouseIsConnected = WidgetsBinding.instance.mouseTracker.mouseIsConnected;
    }

    // If entering inspection mode, show the tip if it was not hidden permanently
    if (!_showInspectionModeTip) {
      setState(() => _showInspectionModeTip = prefs.showInspectionModeTip.value);
    }

    // Toggle the inspection mode state and update the UI by hiding or showing the controls
    setState(() => _inInspectionMode = !_inInspectionMode);

    // Enter or exit fullscreen mode when entering or exiting inspection mode
    _inInspectionMode ? web_utils.enterFullscreen() : web_utils.exitFullscreen();
  }

  /// Performs the actions of the app bar.
  void _onAction(_AppBarActions action) async {
    switch (action) {
      case _AppBarActions.inspectionMode:
        _toggleInspectionMode();
        break;

      case _AppBarActions.toggleInspectionModeTip:
        prefs.showInspectionModeTip.value = !prefs.showInspectionModeTip.value;
        _showInspectionModeTip = prefs.showInspectionModeTip.value;
        setState(() {});
        break;

      case _AppBarActions.help:
        utils.launchUrlExternal(context, urls.helpUrl);
        break;

      case _AppBarActions.support:
        utils.launchUrlExternal(context, urls.supportUrl);
        break;

      case _AppBarActions.supportUs:
        utils.launchUrlExternal(context, urls.supportUsUrl);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color currentColor = TestColor.values[prefs.testColorIndex.value].value;
    final Color contrastColor = utils.getContrastColor(currentColor);

    return Scaffold(
      backgroundColor: currentColor,

      // Capture key events for cycling through test colors and toggling the inspection mode
      body: KeyboardListener(
        focusNode: _bodyFocusNode,
        autofocus: true,
        onKeyEvent: (event) => _handleKeys(event),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Fill the screen with a gesture detector to detect gestures for cycling through test
            // colors and toggling the inspection mode
            Positioned.fill(
              child: GestureDetector(
                // Go to the next color on double tap and hide the cycle part of the tip
                onDoubleTap: () => _nextColor(),
                // Toggle the inspection mode on long press
                onLongPress: () => _toggleInspectionMode(),
              ),
            ),

            // Show UI elements only when not in inspection mode
            if (!_inInspectionMode) ...[
              // Show the app bar in the stack because we want to capture tap events even on the
              // app bar (on areas that do not contain widgets)
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: _AppBar(
                  foregroundColor: contrastColor,
                  inspectionModeTipStatus: prefs.showInspectionModeTip.value,
                  onAction: _onAction,
                ),
              ),

              // Show the control panel in the center of the screen, with color buttons to select
              // the test color
              Center(
                child: TestControlPanel(
                  selectedIndex: prefs.testColorIndex.value,
                  onColorButtonPressed: _onColorButtonPressed,
                ),
              ),
            ],

            /// Show the inspection mode tip when in inspection mode and the tip is not hidden
            if (_inInspectionMode && _showInspectionModeTip)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(32.0),
                child: OnScreenTip(
                  text: strings.testScreenTip(_mouseIsConnected),
                  foregroundColor: contrastColor,
                  onOkPressed: () => setState(() => _showInspectionModeTip = false),
                  onDontShowAgainPressed: () => setState(() {
                    prefs.showInspectionModeTip.value = false;
                    _showInspectionModeTip = false;
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Enum that defines the actions of the app bar.
enum _AppBarActions {
  inspectionMode,
  toggleInspectionModeTip,
  help,
  support,
  supportUs,
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    super.key, // ignore: unused_element
    required this.foregroundColor,
    required this.inspectionModeTipStatus,
    required this.onAction,
  });

  /// The foreground color of the app bar used for the text and icons.
  final Color foregroundColor;

  /// The status of the inspection mode tip menu item (checked or unchecked).
  final bool inspectionModeTipStatus;

  /// The callback that is called when an app bar action is pressed.
  final void Function(_AppBarActions action) onAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      foregroundColor: foregroundColor,

      // The common operations displayed in this app bar
      actions: <Widget>[
        // Add the Toggle Fullscreen button
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor,
            side: BorderSide(color: foregroundColor, width: 2.0),
            visualDensity: VisualDensity.comfortable,
          ),
          onPressed: () => onAction(_AppBarActions.inspectionMode),
          child: const Text(strings.inspectionModeButton),
        ),

        // Add the Popup Menu items
        PopupMenuButton<_AppBarActions>(
          onSelected: onAction,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<_AppBarActions>>[
            // The Inspection mode tip menu item
            // CheckedPopupMenuItem<_AppBarActions>(
            //   value: _AppBarActions.toggleInspectionModeTip,
            //   checked: inspectionModeTipStatus,
            //   child: const Text(strings.inspectionModeTipMenuItem),
            // ),
            PopupMenuItem<_AppBarActions>(
              value: _AppBarActions.toggleInspectionModeTip,
              child: ListTile(
                title: const Text(strings.inspectionModeTipMenuItem),
                trailing: inspectionModeTipStatus
                    ? const Icon(Icons.check_box)
                    : const Icon(Icons.check_box_outline_blank),
              ),
            ),

            const PopupMenuDivider(),

            // The Help menu item
            const PopupMenuItem<_AppBarActions>(
              value: _AppBarActions.help,
              child: Text(strings.helpMenuItem),
            ),

            // The Support menu item
            const PopupMenuItem<_AppBarActions>(
              value: _AppBarActions.support,
              child: Text(strings.supportMenuItem),
            ),

            const PopupMenuDivider(),

            // The Support Us menu item
            const PopupMenuItem<_AppBarActions>(
              value: _AppBarActions.supportUs,
              child: Text(strings.supportUsMenuItem),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
