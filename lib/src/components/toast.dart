// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart';

/// Default duration before toast auto-dismisses.
const _defaultDuration = Duration(milliseconds: 4500);

/// Manages toast notifications: show message, auto-dismiss, manual dismiss.
class Toast {
  final HTMLElement _element;
  late final HTMLElement _messageElement;

  Timer? _dismissTimer;

  Toast(this._element) {
    _queryElements();
    _setupEventHandlers();
  }

  /// Queries child elements.
  void _queryElements() {
    _messageElement = _element.querySelector('[data-message]') as HTMLElement;
  }

  /// Sets up event handlers for dismissing the toast.
  void _setupEventHandlers() {
    // Dismiss button
    final dismissButton = _element.querySelector('[data-action="dismiss"]');
    dismissButton?.addEventListener(
      'click',
      ((Event event) {
        hide();
      }).toJS,
    );
  }

  /// Shows a toast message with optional auto-dismiss duration.
  void show(String message, {Duration duration = _defaultDuration}) {
    // Cancel any existing timer
    _dismissTimer?.cancel();

    // Update message
    _messageElement.textContent = message;

    // Show toast using Popover API
    _element.showPopover();

    // Set up auto-dismiss timer
    _dismissTimer = Timer(duration, hide);
  }

  /// Hides the toast.
  void hide() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    if (isVisible) {
      _element.hidePopover();
    }
  }

  /// Whether the toast is visible.
  bool get isVisible => _element.matches(':popover-open');
}
