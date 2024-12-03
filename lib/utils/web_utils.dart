// This file is part of InjuredPixels (https://www.aurelitec.com/injuredpixels/).
// Copyright 2016-2024 Aurelitec. All rights reserved.
// See the LICENSE file in the project root for license information.
// @author TechAurelian <dev@techaurelian.com> (https://techaurelian.com)

import 'package:web/web.dart';

/// Toggles the fullscreen mode of the web app.
void toggleFullscreen() async {
  if (isDocumentFullscreen()) {
    document.exitFullscreen();
  } else {
    document.documentElement?.requestFullscreen();
  }
}

bool isDocumentFullscreen() => document.fullscreenElement != null;
