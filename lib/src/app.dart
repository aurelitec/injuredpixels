// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:async';

import 'package:signals_core/signals_core.dart';
import 'package:web/web.dart' as web;

import 'components/control_panel.dart';
import 'state/app_state.dart';

/// Global app state instance for debugging from console.
/// Access via: window.setColor(index) in browser console.
late AppState _appState;

/// Main application class that bootstraps and wires everything together.
class App {
  /// Application state.
  final appState = AppState();

  /// Container element for dynamic content.
  late final web.HTMLDivElement _container;

  /// Control panel component.
  late final ControlPanel _controlPanel;

  /// Control panel template.
  late final web.HTMLTemplateElement _panelTemplate;

  /// Help dialog template (used in Phase 6).
  late final web.HTMLTemplateElement _helpTemplate;

  /// Toast template (used in Phase 6).
  late final web.HTMLTemplateElement _toastTemplate;

  /// Timer for touch-and-hold gesture.
  Timer? _touchTimer;

  /// Whether touch moved during touch-and-hold.
  var _touchMoved = false;

  /// Initializes the application and starts the UI.
  void run() {
    _appState = appState;
    _queryElements();
    _createComponents();
    _setupBodyHandlers();
    _setupEffects();
  }

  /// Query DOM elements needed for the app.
  void _queryElements() {
    _container =
        web.document.querySelector('#app-container') as web.HTMLDivElement;
    _panelTemplate = web.document.querySelector('#control-panel')
        as web.HTMLTemplateElement;
    _helpTemplate =
        web.document.querySelector('#help-dialog') as web.HTMLTemplateElement;
    _toastTemplate =
        web.document.querySelector('#toast') as web.HTMLTemplateElement;
  }

  /// Create and initialize components.
  void _createComponents() {
    _controlPanel = ControlPanel(appState, _container, _panelTemplate);

    // Wire callbacks for actions that need app-level coordination
    _controlPanel.onFullscreenToggle = _toggleFullscreen;
    _controlPanel.onHelpToggle = () => appState.toggleHelp();
  }

  /// Set up body event handlers for background interactions.
  void _setupBodyHandlers() {
    final body = web.document.body!;

    // Double-click: next color
    body.onDoubleClick.listen((_) {
      appState.nextColor();
    });

    // Right-click: toggle panel
    body.onContextMenu.listen((event) {
      event.preventDefault();
      appState.togglePanel();
    });

    // Touch and hold for panel toggle (long press)
    body.onTouchStart.listen((_) {
      _touchMoved = false;
      _touchTimer = Timer(const Duration(milliseconds: 500), () {
        if (!_touchMoved) {
          appState.togglePanel();
        }
      });
    });

    body.onTouchMove.listen((_) {
      _touchMoved = true;
      _touchTimer?.cancel();
      _touchTimer = null;
    });

    body.onTouchEnd.listen((_) {
      _touchTimer?.cancel();
      _touchTimer = null;
    });

    body.onTouchCancel.listen((_) {
      _touchTimer?.cancel();
      _touchTimer = null;
    });
  }

  /// Set up reactive effects.
  void _setupEffects() {
    // Background color effect
    effect(() {
      final index = appState.colorIndex.value;
      final hex = _controlPanel.getColorHex(index);
      web.document.body!.style.backgroundColor = hex;
    });

    // Fullscreen icon update effect
    effect(() {
      final isFullscreen = appState.isFullscreen.value;
      _controlPanel.updateFullscreenIcon(isFullscreen);
    });
  }

  /// Toggle fullscreen mode (placeholder until FullscreenService is implemented).
  void _toggleFullscreen() {
    // TODO: Implement in Phase 5 with FullscreenService
    final doc = web.document;
    final docElement = web.document.documentElement!;

    if (doc.fullscreenElement != null) {
      doc.exitFullscreen();
    } else {
      docElement.requestFullscreen();
    }
  }
}

/// Set color by index (0-7) - for console debugging.
/// Usage in browser console: setColor(3) for Cyan
void setColor(int index) {
  if (index >= 0 && index < colorCount) {
    _appState.colorIndex.value = index;
  }
}

/// Get current color index - for console debugging.
int getColor() => _appState.colorIndex.value;

/// Go to next color - for console debugging.
void nextColor() => _appState.nextColor();

/// Go to previous color - for console debugging.
void prevColor() => _appState.previousColor();
