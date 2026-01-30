/**
 * Copyright (c) 2009-2026 Aurelitec
 * https://www.aurelitec.com/injuredpixels/
 * Licensed under the MIT License. See LICENSE file in the project root.
 */

import {
  LeftIcon,
  RightIcon,
  EnterFullscreenIcon,
  ExitFullscreenIcon,
  HideIcon,
  HelpIcon,
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
    <div className="flex items-center justify-between rounded-b-panel bg-panel-toolbar px-8 py-2 select-none">
      {/* Primary actions - left side */}
      <div className="flex items-center gap-toolbar-gap">
        <ToolbarButton
          icon={<LeftIcon />}
          label={strings.PREVIOUS}
          onClick={onPrevious}
        />
        <ToolbarButton
          icon={<RightIcon />}
          label={strings.NEXT}
          onClick={onNext}
        />
        <ToolbarButton
          icon={isFullscreen ? <ExitFullscreenIcon /> : <EnterFullscreenIcon />}
          label={isFullscreen ? strings.EXIT_FULLSCREEN : strings.ENTER_FULLSCREEN}
          onClick={onFullscreen}
          ariaLabel={isFullscreen ? strings.EXIT_FULLSCREEN : strings.ENTER_FULLSCREEN}
        />
      </div>

      {/* UI controls - right side */}
      <div className="flex items-center gap-toolbar-gap">
        <ToolbarButton
          icon={<HideIcon />}
          label={strings.HIDE_CONTROLS}
          onClick={onTogglePanel}
          ariaLabel={strings.HIDE_CONTROL_PANEL}
        />
        <ToolbarButton
          icon={<HelpIcon />}
          label={strings.HELP}
          onClick={onHelp}
        />
      </div>
    </div>
  );
}
