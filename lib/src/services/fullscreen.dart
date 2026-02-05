// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

/// Wraps the Fullscreen API with change notifications.
library;

import 'package:web/web.dart';

/// Whether the document is currently in fullscreen mode.
bool get _isFullscreen => document.fullscreenElement != null;

/// Toggles fullscreen mode.
void toggle() {
  _isFullscreen ? document.exitFullscreen() : document.documentElement?.requestFullscreen();
}
