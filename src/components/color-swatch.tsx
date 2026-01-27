import type { TestColor, ColorIndex } from '../types';

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

/** Individual color swatch with label and selected state indicator */
export function ColorSwatch({
  color,
  isSelected,
  onClick,
}: ColorSwatchProps) {
  return (
    <button
      type="button"
      onClick={onClick}
      className="flex flex-col items-center gap-1 focus:outline-none focus-visible:ring-2 focus-visible:ring-focus-ring focus-visible:ring-offset-2"
      aria-label={`${color.name} color${isSelected ? ' (selected)' : ''}`}
      aria-pressed={isSelected}
    >
      <div
        className="w-swatch h-swatch min-w-swatch-min min-h-swatch-min rounded-swatch border border-swatch-border transition-shadow"
        style={{
          backgroundColor: color.hex,
          ...(isSelected && {
            boxShadow: `var(--shadow-swatch-selected), 0 0 0 2px ${color.contrastBorder}`,
          }),
        }}
      />
      <span className="text-xs text-gray-700 select-none">{color.name}</span>
    </button>
  );
}
