// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:async';

import 'package:signals_core/signals_core.dart';
import 'package:web/web.dart' as web;

import '../state/app_state.dart';

/// Toast notification component for temporary messages.
///
/// Manages:
/// - Toast visibility based on toastMessage signal
/// - Auto-dismiss after timeout
/// - Manual dismiss via close button
class Toast {
  final AppState _appState;
  final web.HTMLDivElement _container;

  /// Auto-dismiss duration.
  static const _autoDismissDuration = Duration(milliseconds: 4500);

  /// The cloned toast element.
  late final web.HTMLElement _toastElement;

  /// Message text element.
  late final web.Element _messageElement;

  /// Auto-dismiss timer.
  Timer? _dismissTimer;

  Toast(this._appState, this._container, web.HTMLTemplateElement template) {
    _cloneTemplate(template);
    _wireHandlers();
    _setupEffects();
  }

  /// Clone template and extract references.
  void _cloneTemplate(web.HTMLTemplateElement template) {
    final content = template.content.cloneNode(true) as web.DocumentFragment;
    _toastElement = content.firstElementChild as web.HTMLElement;
    _messageElement = _toastElement.querySelector('[data-message]')!;
  }

  /// Wire event handlers.
  void _wireHandlers() {
    // Dismiss button
    final dismissBtn = _toastElement.querySelector('[data-action="dismiss"]');
    dismissBtn?.onClick.listen((_) {
      _dismiss();
    });
  }

  /// Set up reactive effects.
  void _setupEffects() {
    var isCurrentlyVisible = false;
    var isAnimating = false;

    effect(() {
      final message = _appState.toastMessage.value;

      if (message != null && !isCurrentlyVisible && !isAnimating) {
        // Show toast
        _messageElement.textContent = message;
        _toastElement.style.opacity = '0';
        _toastElement.style.transform = 'translateY(1rem)';
        _container.append(_toastElement);

        // Trigger reflow then animate in
        // ignore: unnecessary_statements
        _toastElement.offsetHeight; // Force reflow

        _toastElement.style.transition = 'opacity 200ms ease-out, transform 200ms ease-out';
        _toastElement.style.opacity = '1';
        _toastElement.style.transform = 'translateY(0)';

        // Start auto-dismiss timer
        _dismissTimer?.cancel();
        _dismissTimer = Timer(_autoDismissDuration, _dismiss);

        isCurrentlyVisible = true;
      } else if (message == null && isCurrentlyVisible && !isAnimating) {
        // Hide toast with animation
        isAnimating = true;
        _dismissTimer?.cancel();
        _dismissTimer = null;

        _toastElement.style.transition = 'opacity 150ms ease-in, transform 150ms ease-in';
        _toastElement.style.opacity = '0';
        _toastElement.style.transform = 'translateY(1rem)';

        // Remove after animation
        Timer(const Duration(milliseconds: 150), () {
          if (_appState.toastMessage.value == null) {
            _toastElement.remove();
            _toastElement.style.transition = '';
          }
          isAnimating = false;
        });

        isCurrentlyVisible = false;
      }
    });
  }

  /// Dismiss the toast.
  void _dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _appState.toastMessage.value = null;
  }
}
