import { XIcon } from './icons';
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
      <dt className="font-mono text-gray-600 shrink-0">{keys}</dt>
      <dd className="text-gray-800 text-right">{description}</dd>
    </div>
  );
}

/** Section header */
function SectionHeader({ children }: { children: string }) {
  return (
    <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wide mt-4 mb-2 first:mt-0">
      {children}
    </h3>
  );
}

/**
 * Help dialog showing keyboard, mouse, and touch shortcuts.
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
        className="relative bg-dialog-bg rounded-dialog shadow-dialog max-w-sm w-[90vw] p-6"
        style={dialogAnimation}
        onClick={(e) => e.stopPropagation()}
        role="dialog"
        aria-label={strings.HELP}
        aria-modal="true"
      >
        {/* Close button */}
        <button
          onClick={onClose}
          className="absolute top-3 right-3 p-1.5 rounded hover:bg-gray-100 transition-colors"
          aria-label={strings.CLOSE}
        >
          <XIcon className="w-5 h-5 text-gray-500" />
        </button>

        <h2 className="text-lg font-semibold text-gray-900 mb-4">{strings.HELP}</h2>

        <dl className="space-y-1.5 text-sm">
          <SectionHeader>{strings.SECTION_KEYBOARD}</SectionHeader>
          <ShortcutRow keys={strings.KEYS_NUMBERS} description={strings.DESC_JUMP_TO_COLOR} />
          <ShortcutRow keys={strings.KEYS_ARROWS} description={strings.DESC_CYCLE_COLORS} />
          <ShortcutRow keys={strings.KEYS_F} description={strings.DESC_FULLSCREEN} />
          <ShortcutRow keys={strings.KEYS_SPACE} description={strings.DESC_TOGGLE_PANEL} />
          <ShortcutRow keys={strings.KEYS_ESC} description={strings.DESC_EXIT_FULLSCREEN} />

          <SectionHeader>{strings.SECTION_MOUSE}</SectionHeader>
          <ShortcutRow keys={strings.KEYS_DOUBLE_CLICK} description={strings.DESC_NEXT_COLOR} />
          <ShortcutRow keys={strings.KEYS_RIGHT_CLICK} description={strings.DESC_TOGGLE_PANEL} />

          <SectionHeader>{strings.SECTION_TOUCH}</SectionHeader>
          <ShortcutRow keys={strings.KEYS_DOUBLE_TAP} description={strings.DESC_NEXT_COLOR} />
          <ShortcutRow keys={strings.KEYS_TOUCH_HOLD} description={strings.DESC_TOGGLE_PANEL} />
        </dl>
      </div>
    </div>
  );
}
