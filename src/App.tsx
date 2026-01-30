/**
 * Copyright (c) 2009-2026 Aurelitec
 * https://www.aurelitec.com/injuredpixels/
 * Licensed under the MIT License. See LICENSE file in the project root.
 */

import { useState, useCallback, useMemo, useRef } from 'react';
import { TEST_COLORS, COLOR_COUNT, type ColorIndex } from './constants/colors';
import { ColorBackground } from './components/color-background';
import { ControlPanel } from './components/control-panel';
import { ColorSwatches } from './components/color-swatches';
import { ActionToolbar } from './components/action-toolbar';
import { HelpDialog } from './components/help-dialog';
import { Toast } from './components/toast';
import { useLocalStorage } from './hooks/use-local-storage';
import { useFullscreen } from './hooks/use-fullscreen';
import { useReducedMotion } from './hooks/use-reduced-motion';
import { useKeyboardShortcuts } from './hooks/use-keyboard-shortcuts';
import * as strings from './constants/strings';

/** localStorage key for persisting color selection */
const STORAGE_KEY = 'injuredpixels-color';

function App() {
  // Persisted state: last selected color
  const [colorIndex, setColorIndex] = useLocalStorage<ColorIndex>(STORAGE_KEY, 0);

  // UI state (not persisted)
  const [panelVisible, setPanelVisible] = useState(true);
  const [helpOpen, setHelpOpen] = useState(false);
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  // Session flag: has the panel hint been shown this session?
  const hasShownPanelHintRef = useRef(false);

  // Show panel when exiting fullscreen (e.g., user presses Escape as "panic recovery")
  const handleFullscreenExit = useCallback(() => {
    setPanelVisible(true);
  }, []);

  // Hooks
  const { isFullscreen, toggleFullscreen } = useFullscreen({ onExit: handleFullscreenExit });
  const reducedMotion = useReducedMotion();

  // Derived state
  const currentColor = TEST_COLORS[colorIndex];

  // --- Centralized Handlers ---

  const handleSelectColor = useCallback((index: ColorIndex) => {
    setColorIndex(index);
  }, [setColorIndex]);

  const handlePrevious = useCallback(() => {
    setColorIndex((prev) => ((prev - 1 + COLOR_COUNT) % COLOR_COUNT) as ColorIndex);
  }, [setColorIndex]);

  const handleNext = useCallback(() => {
    setColorIndex((prev) => ((prev + 1) % COLOR_COUNT) as ColorIndex);
  }, [setColorIndex]);

  const handleTogglePanel = useCallback(() => {
    if (panelVisible && !hasShownPanelHintRef.current) {
      hasShownPanelHintRef.current = true;
      setToastMessage(strings.CONTROLS_DISPLAY_HINT);
    } else if (!panelVisible) {
      setToastMessage((current) =>
        current === strings.CONTROLS_DISPLAY_HINT ? null : current
      );
    }
    setPanelVisible((prev) => !prev);
  }, [panelVisible]);

  const handleToggleFullscreen = useCallback(() => {
    toggleFullscreen();
  }, [toggleFullscreen]);

  const handleToggleHelp = useCallback(() => {
    setHelpOpen((prev) => !prev);
  }, []);

  const handleDismissToast = useCallback(() => {
    setToastMessage(null);
  }, []);

  // ColorBackground event handlers
  const handleDoubleClick = handleNext;
  const handleContextMenu = handleTogglePanel;

  // Memoize keyboard handlers object to prevent effect re-running
  const keyboardHandlers = useMemo(
    () => ({
      onColorSelect: handleSelectColor,
      onPrevious: handlePrevious,
      onNext: handleNext,
      onToggleFullscreen: handleToggleFullscreen,
      onTogglePanel: handleTogglePanel,
      onToggleHelp: handleToggleHelp,
    }),
    [
      handleSelectColor,
      handlePrevious,
      handleNext,
      handleToggleFullscreen,
      handleTogglePanel,
      handleToggleHelp,
    ]
  );

  // Register keyboard shortcuts
  useKeyboardShortcuts(keyboardHandlers);

  return (
    <>
      <ColorBackground
        color={currentColor.hex}
        onDoubleClick={handleDoubleClick}
        onContextMenu={handleContextMenu}
      />

      <ControlPanel visible={panelVisible} reducedMotion={reducedMotion}>
        <ColorSwatches selectedIndex={colorIndex} onSelect={handleSelectColor} />
        <ActionToolbar
          onPrevious={handlePrevious}
          onNext={handleNext}
          onFullscreen={handleToggleFullscreen}
          onTogglePanel={handleTogglePanel}
          onHelp={handleToggleHelp}
          isFullscreen={isFullscreen}
        />
      </ControlPanel>

      <HelpDialog open={helpOpen} onClose={handleToggleHelp} reducedMotion={reducedMotion} />

      {toastMessage && (
        <Toast
          message={toastMessage}
          onDismiss={handleDismissToast}
          reducedMotion={reducedMotion}
        />
      )}
    </>
  );
}

export default App;
