// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

/// The toast controller that manages the notification toast.
library;

import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart';

/// Default duration before toast auto-dismisses.
const _defaultDuration = Duration(milliseconds: 4500);

/// Timer for auto-dismissing the toast.
Timer? _dismissTimer;

/// The main toast HTML element.
late final HTMLElement _element;

/// The message element within the toast.
late final HTMLElement _messageElement;

/// Whether the toast is visible.
bool get _isVisible => _element.matches(':popover-open');

/// Initializes the toast controller by querying elements and setting up event handlers.
void init() {
  // Query necessary HTML elements
  _element = document.querySelector('#toast') as HTMLElement;
  _messageElement = _element.querySelector('[data-message]') as HTMLElement;

  // Setup the click handler for the dismiss button
  final dismissButton = _element.querySelector('[data-action="dismiss"]');
  dismissButton?.addEventListener('click', ((Event event) => _hide()).toJS);
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
  _dismissTimer = Timer(duration, _hide);
}

/// Hides the toast.
void _hide() {
  _dismissTimer?.cancel();
  _dismissTimer = null;
  if (_isVisible) _element.hidePopover();
}
