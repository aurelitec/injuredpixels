// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

/// The Control Panel controller that manages the control panel UI.
library;

import 'dart:js_interop';

import 'package:web/web.dart';

/// An optional callback invoked after the panel is hidden.
///
/// Can be used to trigger hints or other actions.
late final void Function()? _afterHide;

/// The main control panel HTML element.
late final HTMLElement _element;

/// Callback for when a color swatch is selected, providing the swatch index.
late final void Function(String action)? _onAction;

/// Callback for when a toolbar action button is pressed.
late final void Function(int index)? _onColorSelected;

/// The color swatch elements (live HTMLCollection).
late final HTMLCollection _swatches;

/// The swatches container element.
late final HTMLElement _swatchesContainer;

/// Whether the control panel is visible.
bool get isVisible => !_element.classList.contains('hidden');

/// Returns the computed background color of the swatch at the given index.
String getSwatchBackgroundColor(int index) {
  if (index < 0 || index >= _swatches.length) return '';
  return window.getComputedStyle(_swatchAt(index)).backgroundColor;
}

/// Hides the control panel.
void hide() {
  _element.classList.add('hidden');

  // Invoke after-hide callback if provided
  _afterHide?.call();
}

/// Initializes the control panel controller by assigning callbacks and querying elements.
void init({
  void Function(int index)? onColorSelected,
  void Function(String action)? onAction,
  void Function()? afterHide,
}) {
  _onColorSelected = onColorSelected;
  _onAction = onAction;
  _afterHide = afterHide;

  // Query necessary HTML elements
  _element = document.querySelector('#control-panel') as HTMLElement;
  _initSwatches();
  _initToolbarButtons();
}

/// Selects a swatch by index (updates visual state only).
void selectSwatch(int index) {
  if (index < 0 || index >= _swatches.length) return;
  _swatchesContainer.querySelector('.selected')?.classList.remove('selected');
  _swatchAt(index).classList.add('selected');
}

/// Shows the control panel.
void show() => _element.classList.remove('hidden');

/// Toggles control panel visibility.
void toggle() => _element.classList.toggle('hidden');

/// Queries and wires swatch buttons.
void _initSwatches() {
  _swatchesContainer = document.querySelector('#swatches') as HTMLElement;
  _swatches = _swatchesContainer.children;

  for (var i = 0; i < _swatches.length; i++) {
    final swatch = _swatchAt(i);
    // Capture index in closure
    swatch.addEventListener('click', ((Event event) => _onColorSelected?.call(i)).toJS);
  }
}

/// Queries and wires toolbar buttons.
void _initToolbarButtons() {
  final buttons = _element.querySelectorAll('[data-action]');
  for (var i = 0; i < buttons.length; i++) {
    final button = buttons.item(i) as HTMLElement;
    final action = button.dataset['action'];
    button.addEventListener('click', ((Event event) => _onAction?.call(action)).toJS);
  }
}

/// Helper to get the swatch element at a specific index.
HTMLElement _swatchAt(int index) => _swatches.item(index) as HTMLElement;
