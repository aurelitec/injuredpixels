/**
 * Copyright (c) 2009-2026 Aurelitec
 * https://www.aurelitec.com/injuredpixels/
 * Licensed under the MIT License. See LICENSE file in the project root.
 */

import { useEffect } from 'react';
import { CloseIcon } from './icons';
import * as strings from '../constants/strings';

interface ToastProps {
  /** Toast message content */
  message: string;
  /** Called when toast should be dismissed */
  onDismiss: () => void;
  /** Auto-dismiss duration in ms (default: 4500) */
  duration?: number;
  /** Whether to disable animations */
  reducedMotion?: boolean;
}

/**
 * Bottom-center toast notification with auto-dismiss.
 * Supports manual dismiss via X button.
 */
export function Toast({
  message,
  onDismiss,
  duration = 4500,
  reducedMotion = false,
}: ToastProps) {
  // Auto-dismiss after duration
  useEffect(() => {
    const timer = setTimeout(onDismiss, duration);
    return () => clearTimeout(timer);
  }, [duration, onDismiss]);

  const animationStyle = reducedMotion
    ? {}
    : {
        animation: `toast-slide-in var(--duration-toast-in) ease-out`,
      };

  return (
    <div
      className="fixed bottom-8 left-1/2 -translate-x-1/2 z-50 flex items-center gap-3
        bg-toast-bg text-toast-text px-4 py-3 rounded-toast shadow-toast
        max-w-[90vw] sm:max-w-md"
      style={animationStyle}
      role="status"
      aria-live="polite"
    >
      <span className="text-sm">{message}</span>
      <button
        onClick={onDismiss}
        className="shrink-0 p-1 rounded hover:bg-white/10 transition-colors"
        aria-label={strings.DISMISS}
      >
        <CloseIcon className="w-4 h-4" />
      </button>
    </div>
  );
}
