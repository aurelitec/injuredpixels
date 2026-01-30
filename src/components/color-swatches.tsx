/**
 * Copyright (c) 2009-2026 Aurelitec
 * https://www.aurelitec.com/injuredpixels/
 * Licensed under the MIT License. See LICENSE file in the project root.
 */

import { TEST_COLORS, type ColorIndex } from '../constants/colors';
import { ColorSwatch } from './color-swatch';

interface ColorSwatchesProps {
  /** Currently selected color index (0-7) */
  selectedIndex: ColorIndex;
  /** Called when a swatch is clicked */
  onSelect: (index: ColorIndex) => void;
}

/**
 * Responsive grid of 8 color swatches.
 * - Desktop (lg): 8×1 horizontal
 * - Tablet (md): 4×2 grid
 * - Mobile: 2×4 grid
 * - Mobile landscape: 4×2 grid
 */
export function ColorSwatches({ selectedIndex, onSelect }: ColorSwatchesProps) {
  return (
    <div className="grid grid-cols-4 gap-2 p-3 rounded-t-panel bg-panel-swatch select-none sm:gap-swatch-gap sm:p-panel-padding lg:grid-cols-8 lg:landscape:grid-cols-8">
      {TEST_COLORS.map((color, index) => (
        <ColorSwatch
          key={color.name}
          color={color}
          index={index as ColorIndex}
          isSelected={index === selectedIndex}
          onClick={() => onSelect(index as ColorIndex)}
        />
      ))}
    </div>
  );
}
