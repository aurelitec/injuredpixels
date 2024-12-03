// This file is part of InjuredPixels (https://www.aurelitec.com/injuredpixels/).
// Copyright 2016-2024 Aurelitec. All rights reserved.
// See the LICENSE file in the project root for license information.
// @author TechAurelian <dev@techaurelian.com> (https://techaurelian.com)

import 'dart:async';
// import 'dart:js_interop';

import 'package:web/web.dart';

StreamSubscription<Event>? _fullscreenChangeSubscription;

/// Toggles the fullscreen mode of the web app.
void toggleFullscreen(bool isFullScreen) async {
  if (isFullScreen) {
    document.exitFullscreen();
  } else {
    document.documentElement?.requestFullscreen();
  }
}

void subscribeToFullscreenChange(void Function(Event)? onData) {
  _fullscreenChangeSubscription = document.documentElement?.onFullscreenChange.listen(onData);
  print('Subscribed to fullscreen change events: ${_fullscreenChangeSubscription?.isPaused}');
}

bool isDocumentFullscreen() => document.fullscreenElement != null;

void unsubscribeFromFullscreenChange() {
  _fullscreenChangeSubscription?.cancel();
}
