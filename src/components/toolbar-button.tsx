/**
 * Copyright (c) 2009-2026 Aurelitec
 * https://www.aurelitec.com/injuredpixels/
 * Licensed under the MIT License. See LICENSE file in the project root.
 */

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
  /** Additional CSS classes for the outer button element */
  className?: string;
}

/** Reusable toolbar button with icon + text label */
export function ToolbarButton({
  icon,
  label,
  onClick,
  ariaLabel,
  className,
}: ToolbarButtonProps) {
  return (
    <button
      type="button"
      onClick={onClick}
      aria-label={ariaLabel ?? label}
      className={`flex items-center gap-2 rounded-button px-3 py-2 text-sm font-medium text-toolbar-text transition-colors hover:bg-toolbar-hover focus:outline-none focus-visible:ring-2 focus-visible:ring-focus-ring focus-visible:ring-offset-2 focus-visible:ring-offset-panel-toolbar active:bg-toolbar-active${className ? ` ${className}` : ''}`}
    >
      <span className="text-xl sm:text-lg">{icon}</span>
      <span className="hidden sm:inline">{label}</span>
    </button>
  );
}
