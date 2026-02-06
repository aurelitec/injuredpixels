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

/// Hint message shown when the panel is hidden for the first time.
const _panelHideHint = 'Right-click or press Space to show controls';

late final HTMLElement _body;

var _colorIndex = _defaultColorIndex;

var _hasShownPanelHideHint = false;

/// Runs the application.
void run() {
  _queryElements();
  _createComponents();
  _setupBodyHandlers();
  _setupKeyboardShortcuts();
  _loadPersistedState();
}

/// Creates component instances.
void _createComponents() {
  control_panel_controller.init(
    onColorSelected: _selectColor,
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

/// Handles Escape key.
void _handleEscape() {
  // Show panel if hidden (panic recovery)
  if (!control_panel_controller.isVisible) {
    control_panel_controller.show();
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

/// Queries required elements from the DOM.
void _queryElements() {
  _body = document.body!;
}

/// Selects a color by index.
void _selectColor(int index) {
  if (index < 0 || index >= _colorCount || index == _colorIndex) return;
  _colorIndex = index;

  // Update the body background color
  _body.style.backgroundColor = control_panel_controller.getSwatchBackgroundColor(index);

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
        _handleEscape();
    }
  }

  keyboard_service.setupKeyboardShortcuts(
    onColorSelect: _selectColor,
    onKeyboardAction: handleKeyboardAction,
  );
}
