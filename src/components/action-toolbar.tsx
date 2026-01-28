import {
  ChevronLeftIcon,
  ChevronRightIcon,
  MaximizeIcon,
  MinimizeIcon,
  MenuIcon,
  HelpCircleIcon,
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
  /** Called when Help button is clicked */
  onHelp: () => void;
  /** Whether currently in fullscreen mode */
  isFullscreen: boolean;
}

/** Bottom toolbar with action buttons on left and Help on right */
export function ActionToolbar({
  onPrevious,
  onNext,
  onFullscreen,
  onTogglePanel,
  onHelp,
  isFullscreen,
}: ActionToolbarProps) {
  return (
    <div className="flex items-center justify-between rounded-b-panel bg-panel-toolbar px-8 py-2">
      {/* Primary actions - left side */}
      <div className="flex items-center gap-toolbar-gap">
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

      {/* Help - right side */}
      <ToolbarButton
        icon={<HelpCircleIcon />}
        label="Help"
        onClick={onHelp}
      />
    </div>
  );
}
