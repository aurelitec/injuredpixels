import type { ReactNode } from 'react';

interface ControlPanelProps {
  /** Whether the panel is visible */
  visible: boolean;
  /** Panel content (swatches, toolbar, help button) */
  children: ReactNode;
  /** Whether user prefers reduced motion */
  reducedMotion: boolean;
}

/**
 * Control panel container - centered on screen with shadow.
 * Handles entry/exit animations based on visibility.
 */
export function ControlPanel({
  visible,
  children,
  reducedMotion,
}: ControlPanelProps) {
  // When not visible, don't render at all (for Phase 2, no animations yet)
  if (!visible) {
    return null;
  }

  return (
    <div
      className="fixed inset-0 flex items-center justify-center pointer-events-none"
      role="dialog"
      aria-label="Control panel"
    >
      <div
        className="relative rounded-panel shadow-panel pointer-events-auto"
        style={{
          // Animation will be added in Phase 4
          opacity: visible ? 1 : 0,
          transform: visible ? 'scale(1)' : 'scale(0.95)',
          transition: reducedMotion
            ? 'none'
            : `opacity var(--duration-panel-in) var(--ease-panel-in), transform var(--duration-panel-in) var(--ease-panel-in)`,
        }}
      >
        {children}
      </div>
    </div>
  );
}
