// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:js_interop';

import 'package:web/web.dart';

/// Sets up keyboard shortcuts for the application.
void setupKeyboardShortcuts({
  required void Function(int) onColorSelect,
  required void Function() onPrevious,
  required void Function() onNext,
  required void Function() onFullscreenToggle,
  required void Function() onPanelToggle,
  required void Function() onHelpToggle,
  required void Function() onEscape,
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
          onPrevious();
          event.preventDefault();
        case 'ArrowRight':
          onNext();
          event.preventDefault();
        case 'f':
        case 'F':
          onFullscreenToggle();
          event.preventDefault();
        case ' ':
          onPanelToggle();
          event.preventDefault();
        case '?':
          onHelpToggle();
          event.preventDefault();
        case 'Escape':
          onEscape();
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
