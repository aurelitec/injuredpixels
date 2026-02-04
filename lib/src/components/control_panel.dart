// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:async';

import 'package:signals_core/signals_core.dart';
import 'package:web/web.dart' as web;

import '../state/app_state.dart';

/// Control panel component for color selection and toolbar actions.
///
/// Manages:
/// - Color swatch grid with selection state
/// - Action toolbar (previous, next, fullscreen, hide, help)
/// - Panel visibility with animation via CSS classes
class ControlPanel {
  final AppState _appState;
  final web.HTMLDivElement _container;

  /// The cloned panel element (outer wrapper).
  late final web.Element _panelElement;

  /// Inner panel for animation (has .panel-inner class).
  late final web.HTMLElement _innerPanel;

  /// List of swatch buttons for selection handling.
  final List<web.HTMLButtonElement> _swatchButtons = [];

  /// Map of action name to toolbar button.
  final Map<String, web.HTMLButtonElement> _toolbarButtons = {};

  /// Callback for fullscreen action (wired by App).
  void Function()? onFullscreenToggle;

  /// Callback for help action (wired by App).
  void Function()? onHelpToggle;

  ControlPanel(this._appState, this._container, web.HTMLTemplateElement template) {
    _cloneTemplate(template);
    _wireSwatchHandlers();
    _wireToolbarHandlers();
    _setupEffects();
  }

  /// Clone template and extract references.
  void _cloneTemplate(web.HTMLTemplateElement template) {
    final content = template.content.cloneNode(true) as web.DocumentFragment;
    _panelElement = content.querySelector('[role="dialog"]')!;
    _innerPanel = _panelElement.querySelector('.panel-inner') as web.HTMLElement;

    // Query swatch buttons
    final swatches = _panelElement.querySelectorAll('[data-index]');
    for (var i = 0; i < swatches.length; i++) {
      _swatchButtons.add(swatches.item(i) as web.HTMLButtonElement);
    }

    // Query toolbar buttons
    final buttons = _panelElement.querySelectorAll('[data-action]');
    for (var i = 0; i < buttons.length; i++) {
      final btn = buttons.item(i) as web.HTMLButtonElement;
      final action = btn.getAttribute('data-action');
      if (action != null) {
        _toolbarButtons[action] = btn;
      }
    }

    // Stop click propagation on inner panel to prevent body handlers
    _innerPanel.onClick.listen((event) {
      event.stopPropagation();
    });

    // Also stop double-click and context menu propagation
    _innerPanel.onDoubleClick.listen((event) {
      event.stopPropagation();
    });

    _innerPanel.onContextMenu.listen((event) {
      event.stopPropagation();
    });
  }

  /// Wire swatch click handlers.
  void _wireSwatchHandlers() {
    for (final (i, btn) in _swatchButtons.indexed) {
      btn.onClick.listen((_) {
        _appState.colorIndex.value = i;
      });
    }
  }

  /// Wire toolbar button handlers.
  void _wireToolbarHandlers() {
    _toolbarButtons['previous']?.onClick.listen((_) {
      _appState.previousColor();
    });

    _toolbarButtons['next']?.onClick.listen((_) {
      _appState.nextColor();
    });

    _toolbarButtons['fullscreen']?.onClick.listen((_) {
      onFullscreenToggle?.call();
    });

    _toolbarButtons['hide']?.onClick.listen((_) {
      _appState.panelVisible.value = false;
    });

    _toolbarButtons['help']?.onClick.listen((_) {
      onHelpToggle?.call();
    });
  }

  /// Set up reactive effects.
  void _setupEffects() {
    // Effect: toggle .selected class on swatches
    effect(() {
      final selectedIndex = _appState.colorIndex.value;
      for (final (i, btn) in _swatchButtons.indexed) {
        if (i == selectedIndex) {
          btn.classList.add('selected');
        } else {
          btn.classList.remove('selected');
        }
      }
    });

    // Effect: panel visibility with animation via CSS classes
    var isFirstRender = true;
    var isCurrentlyVisible = false;
    var isAnimating = false;

    effect(() {
      final visible = _appState.panelVisible.value;

      if (visible && !isCurrentlyVisible && !isAnimating) {
        // Show panel
        _innerPanel.classList.remove('hiding');
        _container.append(_panelElement);

        if (!isFirstRender) {
          // Force reflow then animate in
          _innerPanel.offsetHeight;
        }

        _innerPanel.classList.remove('hidden-state');
        _innerPanel.classList.add('visible-state');
        isCurrentlyVisible = true;
      } else if (!visible && isCurrentlyVisible && !isAnimating) {
        // Hide panel with animation
        isAnimating = true;
        _innerPanel.classList.add('hiding');
        _innerPanel.classList.remove('visible-state');
        _innerPanel.classList.add('hidden-state');

        // Remove after animation
        Timer(const Duration(milliseconds: 150), () {
          if (!_appState.panelVisible.value) {
            _panelElement.remove();
            _innerPanel.classList.remove('hiding');
          }
          isAnimating = false;
        });

        isCurrentlyVisible = false;
      }
      isFirstRender = false;
    });
  }

  /// Get the color hex value for a given index.
  String getColorHex(int index) {
    if (index >= 0 && index < _swatchButtons.length) {
      return _swatchButtons[index].getAttribute('data-hex') ?? '#FF0000';
    }
    return '#FF0000';
  }

  /// Get list of swatch buttons (for background color effect in App).
  List<web.HTMLButtonElement> get swatchButtons => _swatchButtons;

  /// Update the fullscreen button icon.
  void updateFullscreenIcon(bool isFullscreen) {
    final btn = _toolbarButtons['fullscreen'];
    if (btn != null) {
      final useElement = btn.querySelector('use');
      if (useElement != null) {
        useElement.setAttribute(
          'href',
          isFullscreen ? '#icon-exit-fullscreen' : '#icon-enter-fullscreen',
        );
      }
    }
  }
}
