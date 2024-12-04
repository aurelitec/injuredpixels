// This file is part of InjuredPixels (https://www.aurelitec.com/injuredpixels/).
// Copyright 2016-2024 Aurelitec. All rights reserved.
// See the LICENSE file in the project root for license information.
// @author TechAurelian <dev@techaurelian.com> (https://techaurelian.com)

/// Web utilities for the InjuredPixels web app.
library;

import 'package:web/web.dart';

/// Makes the web app go fullscreen.
void enterFullscreen() {
  if (!isDocumentFullscreen()) {
    document.documentElement?.requestFullscreen();
  }
}

/// Makes the web app exit fullscreen.
void exitFullscreen() {
  if (isDocumentFullscreen()) {
    document.exitFullscreen();
  }
}

/// Returns whether the web app is in fullscreen mode.
bool isDocumentFullscreen() => document.fullscreenElement != null;
