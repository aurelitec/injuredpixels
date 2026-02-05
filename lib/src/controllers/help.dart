// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

/// The Help controller that manages the help dialog using the native `<dialog>` element.
library;

import 'dart:js_interop';

import 'package:web/web.dart';

/// The main help dialog HTML element.
late final HTMLDialogElement _dialog;

/// Whether the help dialog is visible.
bool get isVisible => _dialog.open;

/// Initializes the help dialog controller by querying elements and setting up event handlers.
void init() {
  // Query necessary HTML elements
  _dialog = document.querySelector('#help-dialog') as HTMLDialogElement;

  // Setup the click handler for the close button
  // Closing the dialog by clicking outside or pressing Escape is handled by the `closedby` attribute
  final closeButton = _dialog.querySelector('[data-action="close"]');
  closeButton?.addEventListener('click', ((Event _) => _hide()).toJS);
}

/// Shows the help dialog as a modal.
void show() => _dialog.showModal();

/// Toggles help dialog visibility.
void toggle() {
  isVisible ? _hide() : show();
}

/// Hides the help dialog.
void _hide() => _dialog.close();
