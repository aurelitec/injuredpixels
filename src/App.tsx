import { TEST_COLORS, type ColorIndex } from './constants/colors';
import { ColorBackground } from './components/color-background';
import { ControlPanel } from './components/control-panel';
import { ColorSwatches } from './components/color-swatches';
import { ActionToolbar } from './components/action-toolbar';
import { HelpButton } from './components/help-button';

function App() {
  // Hardcoded test data for Phase 2 (state will be added in Phase 3)
  const colorIndex: ColorIndex = 0;
  const panelVisible = true;
  const isFullscreen = false;
  const reducedMotion = false;

  const currentColor = TEST_COLORS[colorIndex];

  // Placeholder handlers (will be implemented in Phase 3)
  const handleDoubleClick = () => console.log('Double-click: next color');
  const handleContextMenu = () => console.log('Context menu: toggle panel');
  const handleSelectColor = (index: ColorIndex) =>
    console.log('Select color:', index);
  const handlePrevious = () => console.log('Previous');
  const handleNext = () => console.log('Next');
  const handleFullscreen = () => console.log('Fullscreen');
  const handleTogglePanel = () => console.log('Toggle panel');
  const handleHelp = () => console.log('Help');

  return (
    <>
      <ColorBackground
        color={currentColor.hex}
        onDoubleClick={handleDoubleClick}
        onContextMenu={handleContextMenu}
      />

      <ControlPanel visible={panelVisible} reducedMotion={reducedMotion}>
        <HelpButton onClick={handleHelp} />
        <ColorSwatches
          selectedIndex={colorIndex}
          onSelect={handleSelectColor}
        />
        <ActionToolbar
          onPrevious={handlePrevious}
          onNext={handleNext}
          onFullscreen={handleFullscreen}
          onTogglePanel={handleTogglePanel}
          isFullscreen={isFullscreen}
        />
      </ControlPanel>
    </>
  );
}

export default App;
