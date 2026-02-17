// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

/// Wraps the Fullscreen API to provide a simple interface for toggling fullscreen mode.
library;

import 'package:web/web.dart';

/// Toggles fullscreen mode.
void toggle() {
  final isFullscreen = document.fullscreenElement != null;
  isFullscreen ? document.exitFullscreen() : document.documentElement?.requestFullscreen();
}
