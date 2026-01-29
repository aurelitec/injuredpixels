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

/** Previous button icon (chevron left) */
export function ChevronLeftIcon(props: IconProps) {
  return (
    <svg width="1em" height="1em" {...props}>
      <use href="#icon-chevron-left" />
    </svg>
  );
}

/** Next button icon (chevron right) */
export function ChevronRightIcon(props: IconProps) {
  return (
    <svg width="1em" height="1em" {...props}>
      <use href="#icon-chevron-right" />
    </svg>
  );
}

/** Enter fullscreen icon (expand corners) */
export function MaximizeIcon(props: IconProps) {
  return (
    <svg width="1em" height="1em" {...props}>
      <use href="#icon-maximize" />
    </svg>
  );
}

/** Exit fullscreen icon (collapse corners) */
export function MinimizeIcon(props: IconProps) {
  return (
    <svg width="1em" height="1em" {...props}>
      <use href="#icon-minimize" />
    </svg>
  );
}

/** Toggle panel icon (hamburger menu) */
export function MenuIcon(props: IconProps) {
  return (
    <svg width="1em" height="1em" {...props}>
      <use href="#icon-menu" />
    </svg>
  );
}

/** Help button icon (question mark in circle) */
export function HelpCircleIcon(props: IconProps) {
  return (
    <svg width="1em" height="1em" {...props}>
      <use href="#icon-help-circle" />
    </svg>
  );
}

/** Close/dismiss icon (X) */
export function XIcon(props: IconProps) {
  return (
    <svg width="1em" height="1em" {...props}>
      <use href="#icon-x" />
    </svg>
  );
}
