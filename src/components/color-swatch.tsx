/**
 * Copyright (c) 2009-2026 Aurelitec
 * https://www.aurelitec.com/injuredpixels/
 * Licensed under the MIT License. See LICENSE file in the project root.
 */

import type { TestColor, ColorIndex } from '../types';
import * as strings from '../constants/strings';

interface ColorSwatchProps {
  /** Color definition from TEST_COLORS */
  color: TestColor;
  /** Index in the color array (0-7) */
  index: ColorIndex;
  /** Whether this swatch is currently selected */
  isSelected: boolean;
  /** Called when swatch is clicked */
  onClick: () => void;
}

/** Individual color swatch with label inside and selected state indicator */
export function ColorSwatch({
  color,
  isSelected,
  onClick,
}: ColorSwatchProps) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={`flex h-12 w-12 min-h-swatch min-w-swatch items-center justify-center rounded-swatch border border-swatch-border focus:outline-none focus-visible:ring-2 focus-visible:ring-focus-ring focus-visible:ring-offset-2 sm:h-16 sm:w-16 lg:h-swatch lg:w-swatch ${isSelected ? 'shadow-[0_0_0_3px_var(--color-swatch-selected)]' : ''}`}
      style={{
        backgroundColor: color.hex,
        color: color.contrastColor,
      }}
      aria-label={strings.COLOR_LABEL(color.name, isSelected)}
      aria-pressed={isSelected}
    >
      <span className="text-[0.5rem] font-medium select-none sm:text-xs sm:font-semibold lg:font-bold lg:text-sm">{color.name}</span>
    </button>
  );
}
