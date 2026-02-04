// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../state/app_state.dart';
import 'fullscreen_service.dart';

/// Service for handling keyboard shortcuts.
///
/// Shortcuts:
/// - 1-8: Jump to color
/// - ← →: Cycle colors
/// - F: Toggle fullscreen
/// - Space: Toggle panel visibility
/// - ?: Toggle help dialog
class KeyboardService {
  final AppState _appState;
  final FullscreenService _fullscreenService;

  KeyboardService(this._appState, this._fullscreenService) {
    _setupKeyboardListener();
  }

  /// Set up keyboard event listener.
  void _setupKeyboardListener() {
    web.document.addEventListener(
      'keydown',
      ((web.KeyboardEvent event) => _handleKeyDown(event)).toJS,
    );
  }

  /// Handle keydown events.
  void _handleKeyDown(web.KeyboardEvent event) {
    // Ignore if modifier keys are pressed (except Shift for ?)
    if (event.ctrlKey || event.altKey || event.metaKey) {
      return;
    }

    // Ignore if focus is on an input element
    final target = event.target;
    if (target != null) {
      if (target.isA<web.HTMLInputElement>() ||
          target.isA<web.HTMLTextAreaElement>() ||
          target.isA<web.HTMLSelectElement>()) {
        return;
      }
    }

    final key = event.key;

    // Number keys 1-8: jump to color
    if (key.length == 1 && key.codeUnitAt(0) >= 49 && key.codeUnitAt(0) <= 56) {
      final index = key.codeUnitAt(0) - 49; // '1' -> 0, '8' -> 7
      _appState.colorIndex.value = index;
      event.preventDefault();
      return;
    }

    switch (key) {
      case 'ArrowLeft':
        _appState.previousColor();
        event.preventDefault();

      case 'ArrowRight':
        _appState.nextColor();
        event.preventDefault();

      case 'f':
      case 'F':
        _fullscreenService.toggle();
        event.preventDefault();

      case ' ': // Space
        _appState.togglePanel();
        event.preventDefault();

      case '?':
        _appState.toggleHelp();
        event.preventDefault();
    }
  }
}
