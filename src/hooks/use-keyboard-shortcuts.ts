/**
 * Copyright (c) 2009-2026 Aurelitec
 * https://www.aurelitec.com/injuredpixels/
 * Licensed under the MIT License. See LICENSE file in the project root.
 */

import { useEffect } from 'react';
import { type ColorIndex, COLOR_COUNT } from '../constants/colors';

interface KeyboardHandlers {
  onColorSelect: (index: ColorIndex) => void;
  onPrevious: () => void;
  onNext: () => void;
  onToggleFullscreen: () => void;
  onTogglePanel: () => void;
  onShowPanel: () => void;
  onToggleHelp: () => void;
}

/**
 * Hook that sets up keyboard shortcuts for the app.
 *
 * Shortcuts:
 * - 1-8: Select color directly
 * - ← / →: Previous / Next color
 * - F: Toggle fullscreen
 * - Space: Toggle panel visibility
 * - Escape: Show panel (if hidden) + browser exits fullscreen
 * - ?: Show help dialog
 */
export function useKeyboardShortcuts(handlers: KeyboardHandlers): void {
  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      // Ignore if user is typing in an input field
      const target = event.target as HTMLElement;
      if (target.tagName === 'INPUT' || target.tagName === 'TEXTAREA') {
        return;
      }

      // Number keys 1-8: Direct color selection
      const keyNum = parseInt(event.key, 10);
      if (keyNum >= 1 && keyNum <= COLOR_COUNT) {
        event.preventDefault();
        handlers.onColorSelect((keyNum - 1) as ColorIndex);
        return;
      }

      switch (event.key) {
        case 'ArrowLeft':
          event.preventDefault();
          handlers.onPrevious();
          break;

        case 'ArrowRight':
          event.preventDefault();
          handlers.onNext();
          break;

        case 'f':
        case 'F':
          event.preventDefault();
          handlers.onToggleFullscreen();
          break;

        case ' ':
          event.preventDefault();
          handlers.onTogglePanel();
          break;

        case '?':
          event.preventDefault();
          handlers.onToggleHelp();
          break;

        case 'Escape':
          // Show panel if hidden - don't preventDefault so browser can exit fullscreen
          handlers.onShowPanel();
          break;
      }
    };

    window.addEventListener('keydown', handleKeyDown);

    return () => {
      window.removeEventListener('keydown', handleKeyDown);
    };
  }, [handlers]);
}
