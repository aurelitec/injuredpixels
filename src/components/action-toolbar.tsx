import {
  ChevronLeftIcon,
  ChevronRightIcon,
  MaximizeIcon,
  MinimizeIcon,
  MenuIcon,
  HelpCircleIcon,
} from './icons';
import { ToolbarButton } from './toolbar-button';
import * as strings from '../constants/strings';

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
          label={strings.PREVIOUS}
          onClick={onPrevious}
        />
        <ToolbarButton
          icon={<ChevronRightIcon />}
          label={strings.NEXT}
          onClick={onNext}
        />
        <ToolbarButton
          icon={isFullscreen ? <MinimizeIcon /> : <MaximizeIcon />}
          label={strings.FULLSCREEN}
          onClick={onFullscreen}
          ariaLabel={isFullscreen ? strings.EXIT_FULLSCREEN : strings.ENTER_FULLSCREEN}
        />
        <ToolbarButton
          icon={<MenuIcon />}
          label={strings.TOGGLE_PANEL}
          onClick={onTogglePanel}
          ariaLabel={strings.HIDE_CONTROL_PANEL}
        />
      </div>

      {/* Help - right side */}
      <ToolbarButton
        icon={<HelpCircleIcon />}
        label={strings.HELP}
        onClick={onHelp}
      />
    </div>
  );
}
