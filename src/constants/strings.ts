/**
 * Copyright (c) 2009-2026 Aurelitec
 * https://www.aurelitec.com/injuredpixels/
 * Licensed under the MIT License. See LICENSE file in the project root.
 */

/**
 * Centralized UI strings for InjuredPixels.
 * All user-visible text should be defined here to support language review
 * and future localization.
 */

// --- Toast messages ---
export const CONTROLS_DISPLAY_HINT =
  'Press Space or Escape, right-click, or touch and hold to show controls.';

// --- Action toolbar buttons ---
export const PREVIOUS = 'Previous';
export const NEXT = 'Next';
export const FULLSCREEN = 'Fullscreen';
export const ENTER_FULLSCREEN = 'Enter fullscreen';
export const EXIT_FULLSCREEN = 'Exit fullscreen';
export const HIDE_CONTROLS = 'Hide controls';
export const HIDE_CONTROL_PANEL = 'Hide control panel';
export const HELP = 'Help';

// --- Help dialog ---
export const CLOSE = 'Close';
export const SECTION_KEYBOARD = 'Keyboard';
export const SECTION_MOUSE = 'Mouse';
export const SECTION_TOUCH = 'Touch';

// Shortcut keys (left column)
export const KEYS_NUMBERS = '1-8';
export const KEYS_ARROWS = '← →';
export const KEYS_F = 'F';
export const KEYS_SPACE = 'Space';
export const KEYS_ESC = 'Esc';
export const KEYS_DOUBLE_CLICK = 'Double-click';
export const KEYS_RIGHT_CLICK = 'Right-click';
export const KEYS_DOUBLE_TAP = 'Double-tap';
export const KEYS_TOUCH_HOLD = 'Touch and hold';

// Shortcut descriptions (right column)
export const DESC_JUMP_TO_COLOR = 'Jump to color';
export const DESC_CYCLE_COLORS = 'Cycle colors';
export const DESC_FULLSCREEN = 'Fullscreen';
export const DESC_HIDE_SHOW_CONTROLS = 'Hide/show controls';
export const DESC_EXIT_FULLSCREEN = 'Exit fullscreen';
export const DESC_NEXT_COLOR = 'Next color';

// --- Control panel ---
export const CONTROL_PANEL = 'Control panel';

// --- Color swatch ---
export const COLOR_LABEL = (name: string, isSelected: boolean) =>
  `${name} color${isSelected ? ' (selected)' : ''}`;

// --- About section (in Help dialog) ---
export const APP_NAME = 'InjuredPixels';
export const APP_VERSION = '5.0.0';
export const APP_COPYRIGHT = '\u00A9 2009\u20132026 Aurelitec';
export const APP_HOMEPAGE_URL = 'https://www.aurelitec.com/injuredpixels/';
export const APP_HOMEPAGE_LABEL = 'aurelitec.com/injuredpixels';
export const APP_GITHUB_URL = 'https://github.com/aurelitec/injuredpixels';
export const APP_STAR_ON_GITHUB = 'Star on GitHub';

// --- Toast ---
export const DISMISS = 'Dismiss';
