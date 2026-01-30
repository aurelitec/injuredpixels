/**
 * Copyright (c) 2009-2026 Aurelitec
 * https://www.aurelitec.com/injuredpixels/
 * Licensed under the MIT License. See LICENSE file in the project root.
 */

import { useState, type ReactNode } from 'react';
import * as strings from '../constants/strings';

interface ControlPanelProps {
  /** Whether the panel should be visible */
  visible: boolean;
  /** Panel content (swatches, toolbar, help button) */
  children: ReactNode;
  /** Whether user prefers reduced motion */
  reducedMotion: boolean;
}

/**
 * Control panel container - centered on screen with shadow.
 * Handles entry/exit animations with proper mount/unmount timing.
 */
export function ControlPanel({ visible, children, reducedMotion }: ControlPanelProps) {
  // Track whether panel is mounted (stays true during exit animation)
  const [isMounted, setIsMounted] = useState(visible);

  // When visible becomes true, ensure we're mounted
  if (visible && !isMounted) {
    setIsMounted(true);
  }

  // Handle animation end - unmount after exit animation completes
  const handleAnimationEnd = () => {
    if (!visible) {
      setIsMounted(false);
    }
  };

  // For reduced motion: sync mount state with visibility immediately
  if (reducedMotion && isMounted !== visible) {
    setIsMounted(visible);
  }

  // Don't render if not mounted
  if (!isMounted) {
    return null;
  }

  // Determine animation
  const isEntering = visible;
  const isExiting = !visible && isMounted;

  let animationStyle: React.CSSProperties = {};
  if (!reducedMotion) {
    if (isEntering) {
      animationStyle = {
        animation: 'panel-enter var(--duration-panel-in) var(--ease-panel-in) forwards',
      };
    } else if (isExiting) {
      animationStyle = {
        animation: 'panel-exit var(--duration-panel-out) var(--ease-panel-out) forwards',
      };
    }
  }

  return (
    <div
      className="fixed inset-0 flex items-center justify-center p-4 pointer-events-none"
      role="dialog"
      aria-label={strings.CONTROL_PANEL}
    >
      <div
        className="relative rounded-panel shadow-surface pointer-events-auto"
        style={animationStyle}
        onAnimationEnd={handleAnimationEnd}
      >
        {children}
      </div>
    </div>
  );
}
