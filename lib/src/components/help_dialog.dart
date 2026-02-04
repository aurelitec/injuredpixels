// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:async';

import 'package:signals_core/signals_core.dart';
import 'package:web/web.dart' as web;

import '../state/app_state.dart';

/// Help dialog component showing keyboard, mouse, and touch shortcuts.
///
/// Manages:
/// - Dialog visibility with animation via CSS classes
/// - Close on backdrop click or X button
class HelpDialog {
  final AppState _appState;
  final web.HTMLDivElement _container;

  /// The cloned dialog element (backdrop wrapper, has .dialog-backdrop class).
  late final web.HTMLElement _dialogElement;

  /// Inner dialog panel for animation (has .dialog-inner class).
  late final web.HTMLElement _innerDialog;

  HelpDialog(this._appState, this._container, web.HTMLTemplateElement template) {
    _cloneTemplate(template);
    _wireHandlers();
    _setupEffects();
  }

  /// Clone template and extract references.
  void _cloneTemplate(web.HTMLTemplateElement template) {
    final content = template.content.cloneNode(true) as web.DocumentFragment;
    _dialogElement = content.querySelector('.dialog-backdrop') as web.HTMLElement;
    _innerDialog = _dialogElement.querySelector('.dialog-inner') as web.HTMLElement;
  }

  /// Wire event handlers.
  void _wireHandlers() {
    // Close on backdrop click
    _dialogElement.onClick.listen((event) {
      // Only close if clicking the backdrop itself, not the dialog content
      if (event.target == _dialogElement) {
        _appState.helpOpen.value = false;
      }
    });

    // Close button
    final closeBtn = _innerDialog.querySelector('[data-action="close"]');
    closeBtn?.onClick.listen((_) {
      _appState.helpOpen.value = false;
    });

    // Stop propagation on inner dialog to prevent backdrop click
    _innerDialog.onClick.listen((event) {
      event.stopPropagation();
    });
  }

  /// Set up reactive effects.
  void _setupEffects() {
    var isCurrentlyVisible = false;
    var isAnimating = false;

    effect(() {
      final visible = _appState.helpOpen.value;

      if (visible && !isCurrentlyVisible && !isAnimating) {
        // Show dialog
        _dialogElement.classList.remove('hiding');
        _innerDialog.classList.remove('hiding');
        _container.append(_dialogElement);

        // Force reflow then animate in
        _dialogElement.offsetHeight;

        _dialogElement.classList.remove('hidden-state');
        _dialogElement.classList.add('visible-state');
        _innerDialog.classList.remove('hidden-state');
        _innerDialog.classList.add('visible-state');

        isCurrentlyVisible = true;
      } else if (!visible && isCurrentlyVisible && !isAnimating) {
        // Hide dialog with animation
        isAnimating = true;
        _dialogElement.classList.add('hiding');
        _innerDialog.classList.add('hiding');
        _dialogElement.classList.remove('visible-state');
        _dialogElement.classList.add('hidden-state');
        _innerDialog.classList.remove('visible-state');
        _innerDialog.classList.add('hidden-state');

        // Remove after animation
        Timer(const Duration(milliseconds: 150), () {
          if (!_appState.helpOpen.value) {
            _dialogElement.remove();
            _dialogElement.classList.remove('hiding');
            _innerDialog.classList.remove('hiding');
          }
          isAnimating = false;
        });

        isCurrentlyVisible = false;
      }
    });
  }
}
