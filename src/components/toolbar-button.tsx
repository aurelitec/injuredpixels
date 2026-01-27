import type { ReactNode } from 'react';

interface ToolbarButtonProps {
  /** Icon element to display */
  icon: ReactNode;
  /** Text label for the button */
  label: string;
  /** Called when button is clicked */
  onClick: () => void;
  /** Accessible label (defaults to label) */
  ariaLabel?: string;
}

/** Reusable toolbar button with icon + text label */
export function ToolbarButton({
  icon,
  label,
  onClick,
  ariaLabel,
}: ToolbarButtonProps) {
  return (
    <button
      type="button"
      onClick={onClick}
      aria-label={ariaLabel ?? label}
      className="flex items-center gap-1.5 px-3 py-2 text-sm text-toolbar-text rounded-button hover:bg-toolbar-hover active:bg-toolbar-active focus:outline-none focus-visible:ring-2 focus-visible:ring-focus-ring focus-visible:ring-offset-2 focus-visible:ring-offset-panel-toolbar transition-colors"
    >
      <span className="text-lg">{icon}</span>
      <span>{label}</span>
    </button>
  );
}
