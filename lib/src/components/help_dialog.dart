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
/// - Dialog visibility with animation
/// - Close on backdrop click or X button
class HelpDialog {
  final AppState _appState;
  final web.HTMLDivElement _container;

  /// The cloned dialog element (backdrop wrapper).
  late final web.HTMLElement _dialogElement;

  /// Inner dialog panel for animation.
  late final web.HTMLElement _innerDialog;

  HelpDialog(
      this._appState, this._container, web.HTMLTemplateElement template) {
    _cloneTemplate(template);
    _wireHandlers();
    _setupEffects();
  }

  /// Clone template and extract references.
  void _cloneTemplate(web.HTMLTemplateElement template) {
    final content = template.content.cloneNode(true) as web.DocumentFragment;
    _dialogElement =
        content.querySelector('[data-backdrop]') as web.HTMLElement;
    _innerDialog =
        _dialogElement.querySelector('[role="dialog"]') as web.HTMLElement;
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
        _dialogElement.style.opacity = '0';
        _innerDialog.style.opacity = '0';
        _innerDialog.style.transform = 'scale(0.95)';
        _container.append(_dialogElement);

        // Trigger reflow then animate in
        // ignore: unnecessary_statements
        _dialogElement.offsetHeight; // Force reflow

        _dialogElement.style.transition = 'opacity 200ms ease-out';
        _dialogElement.style.opacity = '1';

        _innerDialog.style.transition =
            'opacity 200ms ease-out, transform 200ms ease-out';
        _innerDialog.style.opacity = '1';
        _innerDialog.style.transform = 'scale(1)';

        isCurrentlyVisible = true;
      } else if (!visible && isCurrentlyVisible && !isAnimating) {
        // Hide dialog with animation
        isAnimating = true;

        _dialogElement.style.transition = 'opacity 150ms ease-in';
        _dialogElement.style.opacity = '0';

        _innerDialog.style.transition = 'opacity 150ms ease-in';
        _innerDialog.style.opacity = '0';

        // Remove after animation
        Timer(const Duration(milliseconds: 150), () {
          if (!_appState.helpOpen.value) {
            _dialogElement.remove();
            _dialogElement.style.transition = '';
            _innerDialog.style.transition = '';
          }
          isAnimating = false;
        });

        isCurrentlyVisible = false;
      }
    });
  }
}
