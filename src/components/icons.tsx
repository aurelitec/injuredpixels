/**
 * Copyright (c) 2009-2026 Aurelitec
 * https://www.aurelitec.com/injuredpixels/
 * Licensed under the MIT License. See LICENSE file in the project root.
 */

import type { SVGProps } from 'react';

type IconProps = SVGProps<SVGSVGElement>;

/**
 * Icon components referencing the SVG sprite defined in index.html.
 * Each icon is a thin wrapper around <use href="#icon-id" />.
 */

/** Previous button icon (Arrow Circle Left icon) */
export function LeftIcon(props: IconProps) {
  return (
    <svg width="1em" height="1em" {...props}>
      <use href="#icon-left" />
    </svg>
  );
}

/** Next button icon (Arrow Circle Right icon) */
export function RightIcon(props: IconProps) {
  return (
    <svg width="1em" height="1em" {...props}>
      <use href="#icon-right" />
    </svg>
  );
}

/** Enter fullscreen icon (Fullscreen icon) */
export function EnterFullscreenIcon(props: IconProps) {
  return (
    <svg width="1em" height="1em" {...props}>
      <use href="#icon-enter-fullscreen" />
    </svg>
  );
}

/** Exit fullscreen icon (Fullscreen Exit icon) */
export function ExitFullscreenIcon(props: IconProps) {
  return (
    <svg width="1em" height="1em" {...props}>
      <use href="#icon-exit-fullscreen" />
    </svg>
  );
}

/** Hide controls icon (Visibility Off icon) */
export function HideIcon(props: IconProps) {
  return (
    <svg width="1em" height="1em" {...props}>
      <use href="#icon-hide" />
    </svg>
  );
}

/** Help button icon (Help icon) */
export function HelpIcon(props: IconProps) {
  return (
    <svg width="1em" height="1em" {...props}>
      <use href="#icon-help" />
    </svg>
  );
}

/** Close/dismiss icon (X) */
export function CloseIcon(props: IconProps) {
  return (
    <svg width="1em" height="1em" {...props}>
      <use href="#icon-close" />
    </svg>
  );
}
