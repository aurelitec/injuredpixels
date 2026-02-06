// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

/// Main application library.
///
/// Orchestrates the app: queries elements, wires events, coordinates components.
library;

import 'dart:js_interop';

import 'package:web/web.dart';

import 'controllers/control_panel.dart' as control_panel_controller;
import 'controllers/help.dart' as help_controller;
import 'controllers/toast.dart' as toast_controller;
import 'services/fullscreen.dart' as fullscreen_service;
import 'services/keyboard.dart' as keyboard_service;
import 'services/storage.dart' as storage_service;

/// Number of test colors available.
const _colorCount = 8;

/// Storage key for persisting the selected color.
const _colorIndexKey = 'colorIndex';

/// Default color index used the first time the app runs or if previously used index is invalid.
const _defaultColorIndex = 0;

/// The currently selected color index (the "state" of the app).
var _colorIndex = _defaultColorIndex;

/// Runs the application.
void run() {
  _createControllers();
  _setupBodyHandlers();
  _setupKeyboardShortcuts();
  _loadPersistedState();
}

/// Initializes the controllers for the main UI components.
void _createControllers() {
  // Tracks whether the panel hide hint has been shown already.
  var hasShownPanelHideHint = false;

  /// Called after the control panel is hidden to show a hint toast once.
  void afterControlPanelHide() {
    if (!hasShownPanelHideHint) {
      hasShownPanelHideHint = true;
      toast_controller.show(.hideHint);
    }
  }

  control_panel_controller.init(
    onColorSelected: _selectColor,
    onAction: _handleAction,
    afterHide: afterControlPanelHide,
  );
  help_controller.init();
  toast_controller.init();
}

/// Handles toolbar button actions.
void _handleAction(control_panel_controller.ToolbarAction action) {
  switch (action) {
    case .previous:
      _previousColor();
    case .next:
      _nextColor();
    case .fullscreen:
      fullscreen_service.toggle();
    case .hide:
      control_panel_controller.hide();
    case .help:
      help_controller.toggle();
  }
}

/// Loads persisted state from storage.
void _loadPersistedState() {
  try {
    final savedIndex = storage_service.getInt(_colorIndexKey);
    _selectColor(savedIndex ?? _defaultColorIndex);
  } on Exception {
    _selectColor(_defaultColorIndex);
  }
}

/// Advances to the next color (wraps around).
void _nextColor() {
  _selectColor((_colorIndex + 1) % _colorCount);
}

/// Goes to the previous color (wraps around).
void _previousColor() {
  _selectColor((_colorIndex - 1 + _colorCount) % _colorCount);
}

/// Selects a color by index.
void _selectColor(int index) {
  if (index < 0 || index >= _colorCount || index == _colorIndex) return;
  _colorIndex = index;

  // Update the body background color
  document.body?.style.backgroundColor = control_panel_controller.getSwatchBackgroundColor(index);

  // Update the control panel selection
  control_panel_controller.selectSwatch(index);

  // Persist selection
  try {
    storage_service.setInt(_colorIndexKey, index);
  } on Exception {
    // Storage write failure is non-critical — color still works in memory
  }
}

/// Sets up body-level event handlers.
void _setupBodyHandlers() {
  /// Handles double-click events on the body to advance to the next color.
  void onDblClick(MouseEvent event) {
    if (event.target == event.currentTarget) _nextColor();
  }

  /// Handles context menu events on the body to toggle the control panel and prevent the menu.
  void onContextMenu(MouseEvent event) {
    event.preventDefault();
    if (event.target == event.currentTarget) control_panel_controller.toggle();
  }

  document.body?.addEventListener('dblclick', onDblClick.toJS);
  document.body?.addEventListener('contextmenu', onContextMenu.toJS);
}

/// Sets up keyboard shortcuts.
void _setupKeyboardShortcuts() {
  /// Handles Escape key presses to show the control panel if hidden (as panic recovery).
  void handleEscape() {
    if (!control_panel_controller.isVisible) {
      control_panel_controller.show();
    }
  }

  /// Handles keyboard actions from the keyboard service.
  void handleKeyboardAction(keyboard_service.KeyboardAction action) {
    switch (action) {
      case .previousColor:
        _previousColor();
      case .nextColor:
        _nextColor();
      case .toggleFullscreen:
        fullscreen_service.toggle();
      case .toggleControlPanel:
        control_panel_controller.toggle();
      case .toggleHelp:
        help_controller.toggle();
      case .escape:
        handleEscape();
    }
  }

  keyboard_service.setupKeyboardShortcuts(
    onColorSelect: _selectColor,
    onKeyboardAction: handleKeyboardAction,
  );
}
