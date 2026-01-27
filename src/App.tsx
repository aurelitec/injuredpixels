import { useState, useCallback, useMemo } from 'react';
import { TEST_COLORS, COLOR_COUNT, type ColorIndex } from './constants/colors';
import { ColorBackground } from './components/color-background';
import { ControlPanel } from './components/control-panel';
import { ColorSwatches } from './components/color-swatches';
import { ActionToolbar } from './components/action-toolbar';
import { HelpButton } from './components/help-button';
import { useLocalStorage } from './hooks/use-local-storage';
import { useFullscreen } from './hooks/use-fullscreen';
import { useReducedMotion } from './hooks/use-reduced-motion';
import { useKeyboardShortcuts } from './hooks/use-keyboard-shortcuts';

/** localStorage key for persisting color selection */
const STORAGE_KEY = 'injuredpixels-color';

function App() {
  // Persisted state: last selected color
  const [colorIndex, setColorIndex] = useLocalStorage<ColorIndex>(STORAGE_KEY, 0);

  // UI state (not persisted)
  const [panelVisible, setPanelVisible] = useState(true);
  const [helpOpen, setHelpOpen] = useState(false);

  // Hooks
  const { isFullscreen, toggleFullscreen } = useFullscreen();
  const reducedMotion = useReducedMotion();

  // Derived state
  const currentColor = TEST_COLORS[colorIndex];

  // --- Centralized Handlers ---
  // These are passed to both useKeyboardShortcuts and UI components

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
    setPanelVisible((prev) => !prev);
  }, []);

  const handleToggleFullscreen = useCallback(() => {
    toggleFullscreen();
  }, [toggleFullscreen]);

  const handleToggleHelp = useCallback(() => {
    setHelpOpen((prev) => !prev);
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
        <HelpButton onClick={handleToggleHelp} />
        <ColorSwatches selectedIndex={colorIndex} onSelect={handleSelectColor} />
        <ActionToolbar
          onPrevious={handlePrevious}
          onNext={handleNext}
          onFullscreen={handleToggleFullscreen}
          onTogglePanel={handleTogglePanel}
          isFullscreen={isFullscreen}
        />
      </ControlPanel>

      {/* HelpDialog and Toast will be added in Phase 4 */}
      {helpOpen && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/50"
          onClick={handleToggleHelp}
        >
          <div
            className="bg-white p-6 rounded-dialog shadow-dialog max-w-sm"
            onClick={(e) => e.stopPropagation()}
          >
            <h2 className="text-lg font-semibold mb-4">Keyboard Shortcuts</h2>
            <dl className="space-y-2 text-sm">
              <div className="flex justify-between">
                <dt className="font-mono">1-8</dt>
                <dd>Select color</dd>
              </div>
              <div className="flex justify-between">
                <dt className="font-mono">← →</dt>
                <dd>Cycle colors</dd>
              </div>
              <div className="flex justify-between">
                <dt className="font-mono">F</dt>
                <dd>Fullscreen</dd>
              </div>
              <div className="flex justify-between">
                <dt className="font-mono">Space</dt>
                <dd>Toggle panel</dd>
              </div>
            </dl>
            <button
              onClick={handleToggleHelp}
              className="mt-4 w-full py-2 bg-gray-100 hover:bg-gray-200 rounded"
            >
              Close
            </button>
          </div>
        </div>
      )}
    </>
  );
}

export default App;
