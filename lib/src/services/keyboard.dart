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
      // Ignore if focus is on an input element
      final target = event.target;
      if (target != null && _isInputElement(target)) {
        return;
      }

      final key = event.key;

      // Number keys 1-8 → select color
      if (key.length == 1 && key.compareTo('1') >= 0 && key.compareTo('8') <= 0) {
        final index = int.parse(key) - 1;
        onColorSelect(index);
        event.preventDefault();
        return;
      }

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
    }).toJS,
  );
}

/// Checks if the target is an input element that should receive keyboard input.
bool _isInputElement(EventTarget target) {
  if (target.isA<HTMLInputElement>()) return true;
  if (target.isA<HTMLTextAreaElement>()) return true;
  if (target.isA<HTMLSelectElement>()) return true;

  // Check for contenteditable
  if (target.isA<HTMLElement>()) {
    final element = target as HTMLElement;
    return element.isContentEditable;
  }

  return false;
}
