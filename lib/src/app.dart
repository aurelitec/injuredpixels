// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:js_interop';

import 'package:web/web.dart';

import 'components/control_panel.dart';

/// Number of test colors available.
const colorCount = 8;

/// Main application class.
///
/// Orchestrates the app: queries elements, wires events, coordinates components.
class App {
  late final HTMLElement _body;
  late final HTMLElement _helpDialogElement;
  late final HTMLElement _toastElement;

  late final ControlPanel _controlPanel;

  var _colorIndex = 0;

  /// Runs the application.
  void run() {
    _queryElements();
    _createComponents();
    _setupBodyHandlers();
    _selectInitialColor();
  }

  /// Queries required elements from the DOM.
  void _queryElements() {
    _body = document.body!;
    _helpDialogElement = document.querySelector('#help-dialog') as HTMLElement;
    _toastElement = document.querySelector('#toast') as HTMLElement;
  }

  /// Creates component instances.
  void _createComponents() {
    final panelElement = document.querySelector('#control-panel') as HTMLElement;
    _controlPanel = ControlPanel(
      panelElement,
      onColorSelected: selectColor,
      onAction: _handleAction,
    );
  }

  /// Sets up body-level event handlers.
  void _setupBodyHandlers() {
    // Double-click → next color
    _body.addEventListener(
      'dblclick',
      ((Event event) {
        _nextColor();
      }).toJS,
    );

    // Right-click → toggle panel
    // CRITICAL: preventDefault must be called synchronously to suppress browser menu
    _body.addEventListener(
      'contextmenu',
      ((Event event) {
        event.preventDefault();
        _controlPanel.toggle();
      }).toJS,
    );
  }

  /// Selects the initial color on startup.
  void _selectInitialColor() {
    selectColor(0);
  }

  /// Selects a color by index.
  void selectColor(int index) {
    if (index < 0 || index >= colorCount) return;
    _colorIndex = index;
    _body.dataset['colorIndex'] = index.toString();
    _controlPanel.selectSwatch(index);
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
        _controlPanel.hide();
      case 'help':
        _toggleHelp();
    }
  }

  /// Toggles fullscreen mode.
  void _toggleFullscreen() {
    // TODO: Implement in Phase 5
  }

  /// Toggles help dialog.
  void _toggleHelp() {
    // TODO: Implement in Phase 6
  }
}
