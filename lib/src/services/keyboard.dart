// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:js_interop';

import 'package:web/web.dart';

/// Actions that can be triggered via keyboard shortcuts.
enum KeyboardAction {
  previousColor,
  nextColor,
  toggleFullscreen,
  toggleControlPanel,
  toggleHelp,
  escape,
}

/// Sets up keyboard shortcuts for the application.
///
/// [onColorSelect] is called with the selected color index (0-7) when a color is selected.
/// [onKeyboardAction] is called with the corresponding [KeyboardAction] for other actions.
void setupKeyboardShortcuts({
  required void Function(int) onColorSelect,
  required void Function(KeyboardAction) onKeyboardAction,
}) {
  document.addEventListener(
    'keydown',
    ((KeyboardEvent event) {
      _handleKeyDown(event, onColorSelect: onColorSelect, onKeyboardAction: onKeyboardAction);
    }).toJS,
  );
}

/// The handler for keydown events to process keyboard shortcuts.
void _handleKeyDown(
  KeyboardEvent event, {
  required void Function(int) onColorSelect,
  required void Function(KeyboardAction) onKeyboardAction,
}) {
  // NOTE: If input elements are added to the app, guard shortcuts against firing during text
  // entry by ignoring events when event.target is an input, textarea, or contenteditable.

  final key = event.key;

  // Number keys 1-8 → select color
  if (key.length == 1 && key.compareTo('1') >= 0 && key.compareTo('8') <= 0) {
    final index = int.parse(key) - 1;
    onColorSelect(index);
    event.preventDefault();
    return;
  }

  // The other keyboard shortcuts
  switch (key) {
    case 'ArrowLeft':
      onKeyboardAction(.previousColor);
      event.preventDefault();
    case 'ArrowRight':
      onKeyboardAction(.nextColor);
      event.preventDefault();
    case 'f':
    case 'F':
      onKeyboardAction(.toggleFullscreen);
      event.preventDefault();
    case ' ':
      onKeyboardAction(.toggleControlPanel);
      event.preventDefault();
    case '?':
      onKeyboardAction(.toggleHelp);
      event.preventDefault();
    case 'Escape':
      onKeyboardAction(.escape);
    // Don't preventDefault for Escape - browser may need it for fullscreen exit
  }
}
