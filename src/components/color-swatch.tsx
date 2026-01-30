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
      className={`w-swatch h-swatch min-w-swatch min-h-swatch rounded-swatch flex items-center justify-center focus:outline-none focus-visible:ring-2 focus-visible:ring-focus-ring focus-visible:ring-offset-2 ${isSelected ? 'border-3 border-swatch-selected' : 'border border-swatch-border'}`}
      style={{
        backgroundColor: color.hex,
        color: color.contrastColor,
      }}
      aria-label={strings.COLOR_LABEL(color.name, isSelected)}
      aria-pressed={isSelected}
    >
      <span className="text-sm font-bold select-none">{color.name}</span>
    </button>
  );
}
