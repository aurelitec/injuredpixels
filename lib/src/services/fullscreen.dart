// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

/// Wraps the Fullscreen API to provide a simple interface for toggling fullscreen mode.
library;

import 'dart:js_interop';

import 'package:web/web.dart';

/// Whether the document is currently in fullscreen mode.
bool get _isFullscreen => document.fullscreenElement != null;

/// Enters fullscreen mode.
void enter() {
  document.documentElement?.requestFullscreen();
}

/// Exits fullscreen mode.
void exit() {
  if (_isFullscreen) document.exitFullscreen();
}

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
