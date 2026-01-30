/**
 * Copyright (c) 2009-2026 Aurelitec
 * https://www.aurelitec.com/injuredpixels/
 * Licensed under the MIT License. See LICENSE file in the project root.
 */

import { CloseIcon, GitHubIcon } from './icons';
import * as strings from '../constants/strings';

interface HelpDialogProps {
  /** Whether the dialog is open */
  open: boolean;
  /** Called when dialog should close */
  onClose: () => void;
  /** Whether to disable animations */
  reducedMotion?: boolean;
}

/** Single shortcut row */
function ShortcutRow({ keys, description }: { keys: string; description: string }) {
  return (
    <div className="flex justify-between gap-4">
      <dt className="font-mono text-gray-500 shrink-0">{keys}</dt>
      <dd className="text-gray-700 text-right">{description}</dd>
    </div>
  );
}

/** Section header */
function SectionHeader({ children }: { children: string }) {
  return (
    <h3 className="text-xs font-semibold text-gray-400 uppercase tracking-wide mt-4 mb-2 first:mt-0">
      {children}
    </h3>
  );
}

/**
 * Help dialog showing keyboard, mouse, and touch shortcuts, plus About info.
 * Two-tone design matching the Control Panel (dark header, light body).
 * Closes on backdrop click or X button.
 */
export function HelpDialog({ open, onClose, reducedMotion = false }: HelpDialogProps) {
  if (!open) return null;

  const backdropAnimation = reducedMotion
    ? {}
    : { animation: 'fade-in var(--duration-panel-in) ease-out' };

  const dialogAnimation = reducedMotion
    ? {}
    : { animation: 'dialog-scale-in var(--duration-panel-in) var(--ease-panel-in)' };

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-dialog-backdrop"
      style={backdropAnimation}
      onClick={onClose}
      role="presentation"
    >
      <div
        className="relative rounded-panel shadow-surface max-w-sm w-[90vw] overflow-hidden"
        style={dialogAnimation}
        onClick={(e) => e.stopPropagation()}
        role="dialog"
        aria-label={strings.HELP}
        aria-modal="true"
      >
        {/* Dark header */}
        <div className="bg-panel-toolbar px-6 py-4 flex items-center justify-between">
          <h2 className="text-base font-semibold text-toolbar-text">{strings.HELP}</h2>
          <button
            onClick={onClose}
            className="p-1.5 rounded hover:bg-toolbar-hover transition-colors"
            aria-label={strings.CLOSE}
          >
            <CloseIcon className="w-5 h-5 text-toolbar-text" />
          </button>
        </div>

        {/* Light body — shortcuts */}
        <div className="bg-panel-swatch px-6 py-5">
          <dl className="space-y-1.5 text-sm">
            <SectionHeader>{strings.SECTION_KEYBOARD}</SectionHeader>
            <ShortcutRow keys={strings.KEYS_NUMBERS} description={strings.DESC_JUMP_TO_COLOR} />
            <ShortcutRow keys={strings.KEYS_ARROWS} description={strings.DESC_CYCLE_COLORS} />
            <ShortcutRow keys={strings.KEYS_F} description={strings.DESC_FULLSCREEN} />
            <ShortcutRow keys={strings.KEYS_SPACE} description={strings.DESC_HIDE_SHOW_CONTROLS} />
            <ShortcutRow keys={strings.KEYS_ESC} description={strings.DESC_EXIT_FULLSCREEN} />
            <ShortcutRow keys={strings.KEYS_QUESTION} description={strings.DESC_TOGGLE_HELP} />

            <SectionHeader>{strings.SECTION_MOUSE}</SectionHeader>
            <ShortcutRow keys={strings.KEYS_DOUBLE_CLICK} description={strings.DESC_NEXT_COLOR} />
            <ShortcutRow keys={strings.KEYS_RIGHT_CLICK} description={strings.DESC_HIDE_SHOW_CONTROLS} />

            <SectionHeader>{strings.SECTION_TOUCH}</SectionHeader>
            <ShortcutRow keys={strings.KEYS_DOUBLE_TAP} description={strings.DESC_NEXT_COLOR} />
            <ShortcutRow keys={strings.KEYS_TOUCH_HOLD} description={strings.DESC_HIDE_SHOW_CONTROLS} />
          </dl>

          {/* About footer */}
          <div className="mt-5 pt-4 border-t border-gray-300 flex justify-between gap-4 text-xs text-gray-500">
            <div className="space-y-1.5">
              <p className="font-semibold text-gray-700">
                {strings.APP_NAME} {strings.APP_VERSION}
              </p>
              <p className="mt-0.5">{strings.APP_COPYRIGHT}</p>
            </div>
            <div className="flex flex-col items-end gap-1 space-y-0.75">
              <a
                href={strings.APP_HOMEPAGE_URL}
                target="_blank"
                rel="noopener noreferrer"
                className="text-gray-500 underline hover:text-gray-700 transition-colors"
              >
                {strings.APP_HOMEPAGE_LABEL}
              </a>
              <a
                href={strings.APP_GITHUB_URL}
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-1 text-gray-500 hover:text-gray-700 transition-colors"
              >
                <GitHubIcon className="w-3.5 h-3.5" />
                {strings.APP_STAR_ON_GITHUB}
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
