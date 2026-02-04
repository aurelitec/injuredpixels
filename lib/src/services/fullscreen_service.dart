// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../state/app_state.dart';

/// Service for managing fullscreen mode.
///
/// Wraps the browser Fullscreen API and syncs state with [AppState.isFullscreen].
/// Implements panic recovery: shows control panel when exiting fullscreen.
class FullscreenService {
  final AppState _appState;

  FullscreenService(this._appState) {
    _setupFullscreenListener();
  }

  /// Whether fullscreen is currently active.
  bool get isFullscreen => web.document.fullscreenElement != null;

  /// Toggle fullscreen mode.
  void toggle() {
    if (isFullscreen) {
      exit();
    } else {
      enter();
    }
  }

  /// Enter fullscreen mode.
  void enter() {
    web.document.documentElement?.requestFullscreen();
  }

  /// Exit fullscreen mode.
  void exit() {
    if (isFullscreen) {
      web.document.exitFullscreen();
    }
  }

  /// Set up listener for fullscreen state changes.
  void _setupFullscreenListener() {
    web.document.addEventListener(
      'fullscreenchange',
      ((web.Event _) => _syncState()).toJS,
    );
  }

  /// Sync the isFullscreen signal with browser state.
  void _syncState() {
    final wasFullscreen = _appState.isFullscreen.value;
    final nowFullscreen = isFullscreen;

    _appState.isFullscreen.value = nowFullscreen;

    // Panic recovery: show panel when exiting fullscreen
    if (wasFullscreen && !nowFullscreen) {
      _appState.panelVisible.value = true;
    }
  }
}
