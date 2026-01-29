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
      className="w-swatch h-swatch min-w-swatch min-h-swatch rounded-swatch border border-swatch-border transition-shadow flex items-center justify-center focus:outline-none focus-visible:ring-2 focus-visible:ring-focus-ring focus-visible:ring-offset-2"
      style={{
        backgroundColor: color.hex,
        color: color.contrastColor,
        ...(isSelected && {
          boxShadow: `var(--shadow-swatch-selected), 0 0 0 2px ${color.contrastColor}`,
        }),
      }}
      aria-label={strings.COLOR_LABEL(color.name, isSelected)}
      aria-pressed={isSelected}
    >
      <span className="text-sm font-bold select-none">{color.name}</span>
    </button>
  );
}
