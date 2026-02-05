// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:js_interop';

import 'package:web/web.dart';

import 'controllers/control_panel.dart' as control_panel_controller;
import 'controllers/help.dart' as help_controller;
import 'controllers/toast.dart' as toast_controller;
import 'services/fullscreen.dart' as fullscreen_service;
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
    fullscreen_service.init(
      onFullscreenChange: _onFullscreenChange,
    );
  }

  /// Creates component instances.
  void _createComponents() {
    control_panel_controller.init(
      onColorSelected: selectColor,
      onAction: _handleAction,
      afterHide: () {
        // Show hint toast on first panel hide per session
        if (!_hasShownPanelHideHint) {
          _hasShownPanelHideHint = true;
          toast_controller.show(_panelHideHint);
        }
      },
    );

    help_controller.init();
    toast_controller.init();
  }

  /// Sets up body-level event handlers.
  void _setupBodyHandlers() {
    // Double-click (only) on the colored body → next color
    document.body?.addEventListener(
      'dblclick',
      ((MouseEvent event) {
        if (event.target == event.currentTarget) _nextColor();
      }).toJS,
    );

    // Right-click (only) on the colored body → toggle control panel
    // Also prevents the context menu from appearing
    document.body?.addEventListener(
      'contextmenu',
      ((MouseEvent event) {
        event.preventDefault();
        if (event.target == event.currentTarget) control_panel_controller.toggle();
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
      onPanelToggle: control_panel_controller.toggle,
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
    _body.style.backgroundColor = control_panel_controller.getSwatchBackgroundColor(index);
    control_panel_controller.selectSwatch(index);
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
        control_panel_controller.hide();
      case 'help':
        _toggleHelp();
    }
  }

  /// Toggles fullscreen mode.
  void _toggleFullscreen() {
    fullscreen_service.toggle();
  }

  /// Handles fullscreen state changes.
  void _onFullscreenChange(bool isFullscreen) {
    // Panic recovery: show panel when exiting fullscreen
    // if (!isFullscreen) {
    //   control_panel_controller.show();
    // }
  }

  /// Handles Escape key.
  void _handleEscape() {
    // Show panel if hidden (panic recovery)
    if (!control_panel_controller.isVisible) {
      control_panel_controller.show();
    }
  }

  /// Toggles help dialog.
  void _toggleHelp() {
    help_controller.toggle();
  }
}
