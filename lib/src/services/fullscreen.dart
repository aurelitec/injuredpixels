// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

/// Wraps the Fullscreen API with change notifications.
library;

import 'dart:js_interop';

import 'package:web/web.dart';

/// Whether the document is currently in fullscreen mode.
bool get _isFullscreen => document.fullscreenElement != null;

/// Initializes the FullscreenService with an optional change callback.
void init({void Function(bool isFullscreen)? onFullscreenChange}) {
  // Set up the event listener for fullscreen changes
  if (onFullscreenChange != null) {
    document.addEventListener(
      'fullscreenchange',
      ((Event _) => onFullscreenChange.call(_isFullscreen)).toJS,
    );
  }
}

/// Toggles fullscreen mode.
void toggle() {
  _isFullscreen ? _exit() : _enter();
}

/// Enters fullscreen mode.
void _enter() {
  document.documentElement?.requestFullscreen();
}

/// Exits fullscreen mode.
void _exit() {
  if (_isFullscreen) document.exitFullscreen();
}
