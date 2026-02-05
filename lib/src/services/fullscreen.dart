// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:js_interop';

import 'package:web/web.dart';

/// Wraps the Fullscreen API with change notifications.
class FullscreenService {
  final void Function(bool isFullscreen)? onFullscreenChange;

  FullscreenService({this.onFullscreenChange}) {
    _setupListener();
  }

  /// Sets up the fullscreenchange event listener.
  void _setupListener() {
    document.addEventListener(
      'fullscreenchange',
      ((Event event) {
        onFullscreenChange?.call(isFullscreen);
      }).toJS,
    );
  }

  /// Whether the document is currently in fullscreen mode.
  bool get isFullscreen => document.fullscreenElement != null;

  /// Enters fullscreen mode.
  void enter() {
    document.documentElement?.requestFullscreen();
  }

  /// Exits fullscreen mode.
  void exit() {
    if (isFullscreen) {
      document.exitFullscreen();
    }
  }

  /// Toggles fullscreen mode.
  void toggle() {
    if (isFullscreen) {
      exit();
    } else {
      enter();
    }
  }
}
