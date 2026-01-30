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
 * - Default: 4×2 grid (compact gap/padding)
 * - sm+: 4×2 grid (full gap/padding)
 * - md+: 8×1 horizontal row
 */
export function ColorSwatches({ selectedIndex, onSelect }: ColorSwatchesProps) {
  return (
    <div className="grid grid-cols-4 justify-items-center gap-2 rounded-t-panel bg-panel-swatch p-3 select-none sm:gap-swatch-gap md:grid-cols-8 sm:p-panel-padding">
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
