// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:js_interop';

import 'package:web/web.dart';

/// Number of test colors available.
const colorCount = 8;

/// Main application class.
///
/// Orchestrates the app: queries elements, wires events, coordinates components.
class App {
  late final HTMLElement _body;
  late final HTMLElement _controlPanel;
  late final HTMLElement _helpDialog;
  late final HTMLElement _toast;

  var _colorIndex = 0;

  /// Runs the application.
  void run() {
    _queryElements();
    _setupBodyHandlers();
    _setupPanelEventBlocking();
    _selectInitialSwatch();
  }

  /// Queries required elements from the DOM.
  void _queryElements() {
    _body = document.body!;
    _controlPanel = document.querySelector('#control-panel') as HTMLElement;
    _helpDialog = document.querySelector('#help-dialog') as HTMLElement;
    _toast = document.querySelector('#toast') as HTMLElement;
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
        _togglePanel();
      }).toJS,
    );
  }

  /// Prevents body handlers from firing when interacting with the control panel.
  void _setupPanelEventBlocking() {
    for (final eventType in ['click', 'dblclick', 'contextmenu']) {
      _controlPanel.addEventListener(
        eventType,
        ((Event event) {
          event.stopPropagation();
        }).toJS,
      );
    }
  }

  /// Selects the initial swatch (index 0) on startup.
  void _selectInitialSwatch() {
    _updateSwatchSelection(0);
  }

  /// Selects a color by index.
  void selectColor(int index) {
    if (index < 0 || index >= colorCount) return;
    _colorIndex = index;
    _body.dataset['colorIndex'] = index.toString();
    _updateSwatchSelection(index);
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

  /// Toggles control panel visibility.
  void _togglePanel() {
    _controlPanel.classList.toggle('hidden');
  }

  /// Shows the control panel.
  void _showPanel() {
    _controlPanel.classList.remove('hidden');
  }

  /// Hides the control panel.
  void _hidePanel() {
    _controlPanel.classList.add('hidden');
  }

  /// Whether the control panel is visible.
  bool get _isPanelVisible => !_controlPanel.classList.contains('hidden');

  /// Updates the selected state on swatches.
  void _updateSwatchSelection(int index) {
    final swatches = _controlPanel.querySelectorAll('[data-index]');
    for (var i = 0; i < swatches.length; i++) {
      final swatch = swatches.item(i) as HTMLElement;
      final swatchIndex = int.tryParse(swatch.dataset['index']);
      if (swatchIndex == index) {
        swatch.classList.add('selected');
      } else {
        swatch.classList.remove('selected');
      }
    }
  }
}
