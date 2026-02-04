// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'package:signals_core/signals_core.dart';

/// Number of test colors available.
const colorCount = 8;

/// Application state managed via signals.
///
/// All UI state is reactive — changes automatically trigger effects
/// that update the DOM.
class AppState {
  /// Currently selected color index (0-7).
  /// Persisted to localStorage.
  final colorIndex = signal(0);

  /// Whether the control panel is visible.
  final panelVisible = signal(true);

  /// Whether the help dialog is open.
  final helpOpen = signal(false);

  /// Current toast message, or null if no toast is shown.
  final toastMessage = signal<String?>(null);

  /// Whether the app is in fullscreen mode.
  /// Synced with browser fullscreen state.
  final isFullscreen = signal(false);

  /// Select the previous color (with wrap-around).
  void previousColor() {
    colorIndex.value = (colorIndex.value - 1 + colorCount) % colorCount;
  }

  /// Select the next color (with wrap-around).
  void nextColor() {
    colorIndex.value = (colorIndex.value + 1) % colorCount;
  }

  /// Toggle control panel visibility.
  void togglePanel() {
    panelVisible.value = !panelVisible.value;
  }

  /// Toggle help dialog visibility.
  void toggleHelp() {
    helpOpen.value = !helpOpen.value;
  }
}
