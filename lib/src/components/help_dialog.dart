// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:js_interop';

import 'package:web/web.dart';

/// Manages the help dialog using the native `<dialog>` element.
class HelpDialog {
  final HTMLDialogElement _dialog;

  HelpDialog(this._dialog) {
    _setupEventHandlers();
  }

  /// Sets up event handlers for closing the dialog.
  void _setupEventHandlers() {
    // Close button
    final closeButton = _dialog.querySelector('[data-action="close"]');
    closeButton?.addEventListener(
      'click',
      ((Event event) {
        hide();
      }).toJS,
    );

    // Backdrop click - native dialog fires click on the dialog element itself
    // when clicking the backdrop (::backdrop)
    _dialog.addEventListener(
      'click',
      ((MouseEvent event) {
        // Close only if click is on the dialog element (backdrop area)
        // not on its children (the actual content)
        if (event.target == _dialog) {
          hide();
        }
      }).toJS,
    );
  }

  /// Shows the help dialog as a modal.
  void show() => _dialog.showModal();

  /// Hides the help dialog.
  void hide() => _dialog.close();

  /// Toggles help dialog visibility.
  void toggle() {
    if (isVisible) {
      hide();
    } else {
      show();
    }
  }

  /// Whether the help dialog is visible.
  bool get isVisible => _dialog.open;
}
