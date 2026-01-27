import {
  ChevronLeftIcon,
  ChevronRightIcon,
  MaximizeIcon,
  MinimizeIcon,
  MenuIcon,
} from './icons';
import { ToolbarButton } from './toolbar-button';

interface ActionToolbarProps {
  /** Called when Previous button is clicked */
  onPrevious: () => void;
  /** Called when Next button is clicked */
  onNext: () => void;
  /** Called when Fullscreen button is clicked */
  onFullscreen: () => void;
  /** Called when Toggle Panel button is clicked */
  onTogglePanel: () => void;
  /** Whether currently in fullscreen mode */
  isFullscreen: boolean;
}

/** Bottom toolbar with Previous, Next, Fullscreen, and Toggle Panel buttons */
export function ActionToolbar({
  onPrevious,
  onNext,
  onFullscreen,
  onTogglePanel,
  isFullscreen,
}: ActionToolbarProps) {
  return (
    <div className="flex justify-evenly items-center gap-toolbar-gap p-2 bg-panel-toolbar rounded-b-panel">
      <ToolbarButton
        icon={<ChevronLeftIcon />}
        label="Previous"
        onClick={onPrevious}
      />
      <ToolbarButton
        icon={<ChevronRightIcon />}
        label="Next"
        onClick={onNext}
      />
      <ToolbarButton
        icon={isFullscreen ? <MinimizeIcon /> : <MaximizeIcon />}
        label="Fullscreen"
        onClick={onFullscreen}
        ariaLabel={isFullscreen ? 'Exit fullscreen' : 'Enter fullscreen'}
      />
      <ToolbarButton
        icon={<MenuIcon />}
        label="Toggle this panel"
        onClick={onTogglePanel}
        ariaLabel="Hide control panel"
      />
    </div>
  );
}
