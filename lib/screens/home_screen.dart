// This file is part of InjuredPixels (https://www.aurelitec.com/injuredpixels/).
// Copyright 2016-2024 Aurelitec. All rights reserved.
// See the LICENSE file in the project root for license information.
// @author TechAurelian <dev@techaurelian.com> (https://techaurelian.com)

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/preferences.dart' as prefs;
import '../common/strings.dart' as strings;
import '../models/test_color.dart';
import '../utils/color_utils.dart' as color_utils;
import '../widgets/on_screen_tip.dart';
import '../widgets/test_control_panel.dart';

/// The Test screen that shows a full-screen color to let the user inspect the display for defects.
///
/// The screen allows the user to cycle through a list of test colors and to show/hide a control
/// panel with color buttons to select the test color.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final bool _mouseIsConnected;

  /// The focus node for the body of the screen, used to capture key events.
  late final FocusNode _bodyFocusNode;

  /// Whether the control panel is currently visible.
  bool _showControlPanel = true;

  @override
  void initState() {
    super.initState();
    _bodyFocusNode = FocusNode();

    // Disable the context menu on the web platform to be able to capture long press events
    if (kIsWeb) BrowserContextMenu.disableContextMenu();

    _mouseIsConnected = WidgetsBinding.instance.mouseTracker.mouseIsConnected;
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

  /// Handles the key events for changing colors and toggling the control panel visibility.
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
      // Toggle the control panel visibility when the space key is pressed
      case LogicalKeyboardKey.space:
        _toggleControlPanelVisibility();
        break;
    }
  }

  /// Toggles the visibility of the control panel.
  void _toggleControlPanelVisibility() {
    setState(() => _showControlPanel = !_showControlPanel);
  }

  @override
  Widget build(BuildContext context) {
    final Color currentColor = TestColor.values[prefs.testColorIndex.value].value;
    final Color contrastColor = color_utils.contrastColor(currentColor);

    return Scaffold(
      backgroundColor: currentColor,

      // Use a KeyboardListener to capture key events for cycling through test colors and toggling
      // the control panel visibility
      body: KeyboardListener(
        focusNode: _bodyFocusNode,
        autofocus: true,
        onKeyEvent: (event) => _handleKeys(event),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Fill the screen with a gesture detector to detect gestures for cycling through test
            // colors and toggling the control panel visibility
            Positioned.fill(
              child: GestureDetector(
                // Go to the next color on double tap and hide the cycle part of the tip
                onDoubleTap: () => _nextColor(),
                // Toggle the control panel visibility on long press and hide the control panel part of the tip
                onLongPress: () => _toggleControlPanelVisibility(),
              ),
            ),

            // Because we don't use an app bar to enlarge the gesture area for toggling the
            // inspection mode, manually add the back to home button in the top left corner
            if (_showControlPanel) ...[
              Positioned(
                top: 8.0,
                left: 8.0,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: color_utils.contrastColor(currentColor),
                  ),
                  onPressed: Navigator.of(context).pop,
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

              /// Show the tip text at the bottom of the screen
              Positioned(
                bottom: 32.0,
                left: 16.0,
                right: 16.0,
                child: OnScreenTip(
                  text: strings.testScreenTip(_mouseIsConnected),
                  foregroundColor: contrastColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
