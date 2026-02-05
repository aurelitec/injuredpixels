// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:js_interop';

import 'package:web/web.dart';

/// Manages the help dialog UI: visibility, close actions.
class HelpDialog {
  final HTMLElement _element;
  late final HTMLElement _innerDialog;

  HelpDialog(this._element) {
    _queryElements();
    _setupEventHandlers();
  }

  /// Queries child elements.
  void _queryElements() {
    _innerDialog = _element.querySelector('.help-dialog-inner') as HTMLElement;
  }

  /// Sets up event handlers for closing the dialog.
  void _setupEventHandlers() {
    // Close button
    final closeButton = _element.querySelector('[data-action="close"]');
    closeButton?.addEventListener(
      'click',
      ((Event event) {
        hide();
      }).toJS,
    );

    // Backdrop click (click on backdrop but not on inner dialog)
    _element.addEventListener(
      'click',
      ((Event event) {
        // Only close if click is directly on backdrop (not bubbled from inner)
        if (event.target == _element) {
          hide();
        }
      }).toJS,
    );

    // Prevent clicks on inner dialog from closing
    _innerDialog.addEventListener(
      'click',
      ((Event event) {
        event.stopPropagation();
      }).toJS,
    );
  }

  /// Shows the help dialog.
  void show() => _element.classList.remove('hidden');

  /// Hides the help dialog.
  void hide() => _element.classList.add('hidden');

  /// Toggles help dialog visibility.
  void toggle() => _element.classList.toggle('hidden');

  /// Whether the help dialog is visible.
  bool get isVisible => !_element.classList.contains('hidden');
}
