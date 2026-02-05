// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:js_interop';

import 'package:web/web.dart';

/// Manages the control panel UI: swatches, toolbar, visibility.
class ControlPanel {
  final HTMLElement _element;
  final void Function(int index)? onColorSelected;
  final void Function(String action)? onAction;

  final List<HTMLElement> _swatches = [];
  late final HTMLElement _fullscreenButton;
  late final SVGUseElement _fullscreenIcon;
  late final HTMLElement _fullscreenLabel;

  var _selectedIndex = 0;

  ControlPanel(
    this._element, {
    this.onColorSelected,
    this.onAction,
  }) {
    _querySwatches();
    _queryToolbarButtons();
    _setupEventBlocking();
  }

  /// Queries and wires swatch buttons.
  void _querySwatches() {
    final swatchElements = _element.querySelectorAll('[data-index]');
    for (var i = 0; i < swatchElements.length; i++) {
      final swatch = swatchElements.item(i) as HTMLElement;
      _swatches.add(swatch);

      swatch.addEventListener(
        'click',
        ((Event event) {
          final index = int.tryParse(swatch.dataset['index']);
          if (index != null) {
            onColorSelected?.call(index);
          }
        }).toJS,
      );
    }
  }

  /// Queries and wires toolbar buttons.
  void _queryToolbarButtons() {
    final buttons = _element.querySelectorAll('[data-action]');
    for (var i = 0; i < buttons.length; i++) {
      final button = buttons.item(i) as HTMLElement;
      final action = button.dataset['action'];

      // Store reference to fullscreen button for later updates
      if (action == 'fullscreen') {
        _fullscreenButton = button;
        _fullscreenIcon = button.querySelector('use') as SVGUseElement;
        _fullscreenLabel = button.querySelector('.toolbar-btn-label') as HTMLElement;
      }

      button.addEventListener(
        'click',
        ((Event event) {
          onAction?.call(action);
        }).toJS,
      );
    }
  }

  /// Prevents body handlers from firing when interacting with the panel.
  void _setupEventBlocking() {
    for (final eventType in ['click', 'dblclick', 'contextmenu']) {
      _element.addEventListener(
        eventType,
        ((Event event) {
          event.stopPropagation();
          // Also prevent default for contextmenu to suppress browser menu
          if (eventType == 'contextmenu') {
            event.preventDefault();
          }
        }).toJS,
      );
    }
  }

  /// Shows the control panel.
  void show() => _element.classList.remove('hidden');

  /// Hides the control panel.
  void hide() => _element.classList.add('hidden');

  /// Toggles control panel visibility.
  void toggle() => _element.classList.toggle('hidden');

  /// Whether the control panel is visible.
  bool get isVisible => !_element.classList.contains('hidden');

  /// Selects a swatch by index (updates visual state only).
  void selectSwatch(int index) {
    if (index < 0 || index >= _swatches.length) return;

    // Remove selection from previous swatch
    if (_selectedIndex >= 0 && _selectedIndex < _swatches.length) {
      _swatches[_selectedIndex].classList.remove('selected');
    }

    // Add selection to new swatch
    _swatches[index].classList.add('selected');
    _selectedIndex = index;
  }

  /// Gets the currently selected swatch index.
  int get selectedIndex => _selectedIndex;

  /// Updates the fullscreen button state.
  void updateFullscreenButton(bool isFullscreen) {
    final iconId = isFullscreen ? '#icon-exit-fullscreen' : '#icon-enter-fullscreen';
    final label = isFullscreen
        ? _fullscreenButton.dataset['labelExit']
        : _fullscreenButton.dataset['labelEnter'];

    _fullscreenIcon.href.baseVal = iconId;
    _fullscreenLabel.textContent = label;
  }
}
