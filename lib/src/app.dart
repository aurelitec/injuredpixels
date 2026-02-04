// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'package:signals_core/signals_core.dart';
import 'package:web/web.dart' as web;

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

  /// Control panel template.
  late final web.HTMLTemplateElement _panelTemplate;

  /// Help dialog template.
  late final web.HTMLTemplateElement _helpTemplate;

  /// Toast template.
  late final web.HTMLTemplateElement _toastTemplate;

  /// List of swatch buttons (for reading color values).
  final List<web.HTMLButtonElement> _swatchButtons = [];

  /// Initializes the application and starts the UI.
  void run() {
    _appState = appState;
    _queryElements();
    _setupEffects();
  }

  /// Query DOM elements needed for the app.
  void _queryElements() {
    _container =
        web.document.querySelector('#app-container') as web.HTMLDivElement;
    _panelTemplate =
        web.document.querySelector('#control-panel') as web.HTMLTemplateElement;
    _helpTemplate =
        web.document.querySelector('#help-dialog') as web.HTMLTemplateElement;
    _toastTemplate =
        web.document.querySelector('#toast') as web.HTMLTemplateElement;

    // Query swatch buttons from the template for color data
    final panelContent = _panelTemplate.content;
    final buttons = panelContent.querySelectorAll('[data-index]');
    for (var i = 0; i < buttons.length; i++) {
      _swatchButtons.add(buttons.item(i) as web.HTMLButtonElement);
    }
  }

  /// Set up reactive effects.
  void _setupEffects() {
    // Background color effect
    effect(() {
      final index = appState.colorIndex.value;
      final hex = _swatchButtons[index].getAttribute('data-hex') ?? '#FF0000';
      web.document.body!.style.backgroundColor = hex;
    });
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
