// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:js_interop';

import 'package:web/web.dart';

import 'controllers/control_panel.dart';
import 'controllers/help_dialog.dart';
import 'controllers/toast.dart' as toast_controller;
import 'services/fullscreen.dart';
import 'services/keyboard.dart';
import 'services/storage.dart';

/// Number of test colors available.
const colorCount = 8;

/// Storage key for persisting the selected color.
const _colorIndexKey = 'colorIndex';

/// Hint message shown when the panel is hidden for the first time.
const _panelHideHint = 'Right-click or press Space to show controls';

/// Main application class.
///
/// Orchestrates the app: queries elements, wires events, coordinates components.
class App {
  late final HTMLElement _body;

  late final ControlPanel _controlPanel;
  late final HelpDialog _helpDialog;

  late final FullscreenService _fullscreen;
  late final StorageService _storage;

  var _colorIndex = 0;
  var _hasShownPanelHideHint = false;

  /// Runs the application.
  void run() {
    _queryElements();
    _createServices();
    _createComponents();
    _setupBodyHandlers();
    _setupKeyboardShortcuts();
    _loadPersistedState();
  }

  /// Queries required elements from the DOM.
  void _queryElements() {
    _body = document.body!;
  }

  /// Creates service instances.
  void _createServices() {
    _storage = StorageService();
    _fullscreen = FullscreenService(
      onFullscreenChange: _onFullscreenChange,
    );
  }

  /// Creates component instances.
  void _createComponents() {
    final panelElement = document.querySelector('#control-panel') as HTMLElement;
    _controlPanel = ControlPanel(
      panelElement,
      onColorSelected: selectColor,
      onAction: _handleAction,
    );

    final helpDialogElement = document.querySelector('#help-dialog') as HTMLDialogElement;
    _helpDialog = HelpDialog(helpDialogElement);

    toast_controller.init();
  }

  /// Sets up body-level event handlers.
  void _setupBodyHandlers() {
    // Double-click → next color
    document.addEventListener(
      'dblclick',
      ((MouseEvent event) {
        _nextColor();
      }).toJS,
    );

    // Right-click → toggle panel
    // CRITICAL: preventDefault must be called synchronously to suppress browser menu
    document.addEventListener(
      'contextmenu',
      ((MouseEvent event) {
        event.preventDefault();
        _togglePanel();
      }).toJS,
    );
  }

  /// Sets up keyboard shortcuts.
  void _setupKeyboardShortcuts() {
    setupKeyboardShortcuts(
      onColorSelect: selectColor,
      onPrevious: _previousColor,
      onNext: _nextColor,
      onFullscreenToggle: _toggleFullscreen,
      onPanelToggle: _togglePanel,
      onHelpToggle: _toggleHelp,
      onEscape: _handleEscape,
    );
  }

  /// Loads persisted state from storage.
  void _loadPersistedState() {
    final savedIndex = _storage.read<int>(_colorIndexKey);
    selectColor(savedIndex ?? 0);
  }

  /// Selects a color by index.
  void selectColor(int index) {
    if (index < 0 || index >= colorCount) return;
    _colorIndex = index;
    _body.dataset['colorIndex'] = index.toString();
    _controlPanel.selectSwatch(index);
    _storage.write(_colorIndexKey, index);
  }

  /// Gets the current color index.
  int get colorIndex => _colorIndex;

  /// Advances to the next color (wraps around).
  void _nextColor() {
    selectColor((_colorIndex + 1) % colorCount);
  }

  /// Goes to the previous color (wraps around).
  void _previousColor() {
    selectColor((_colorIndex - 1 + colorCount) % colorCount);
  }

  /// Handles toolbar button actions.
  void _handleAction(String action) {
    switch (action) {
      case 'previous':
        _previousColor();
      case 'next':
        _nextColor();
      case 'fullscreen':
        _toggleFullscreen();
      case 'hide':
        _hidePanel();
      case 'help':
        _toggleHelp();
    }
  }

  /// Toggles control panel visibility.
  void _togglePanel() {
    if (_controlPanel.isVisible) {
      _hidePanel();
    } else {
      _controlPanel.show();
    }
  }

  /// Hides control panel and shows hint toast on first hide.
  void _hidePanel() {
    _controlPanel.hide();

    // Show hint toast on first panel hide per session
    if (!_hasShownPanelHideHint) {
      _hasShownPanelHideHint = true;
      toast_controller.show(_panelHideHint);
    }
  }

  /// Toggles fullscreen mode.
  void _toggleFullscreen() {
    _fullscreen.toggle();
  }

  /// Handles fullscreen state changes.
  void _onFullscreenChange(bool isFullscreen) {
    _controlPanel.updateFullscreenButton(isFullscreen);

    // Panic recovery: show panel when exiting fullscreen
    if (!isFullscreen) {
      _controlPanel.show();
    }
  }

  /// Handles Escape key.
  void _handleEscape() {
    // Close help dialog if open
    if (_helpDialog.isVisible) {
      _helpDialog.hide();
      return;
    }

    // Show panel if hidden (panic recovery)
    if (!_controlPanel.isVisible) {
      _controlPanel.show();
    }
  }

  /// Toggles help dialog.
  void _toggleHelp() {
    _helpDialog.toggle();
  }
}
