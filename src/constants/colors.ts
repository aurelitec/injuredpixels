
/** Pre-defined contrast colors */
const LIGHT_CONTRAST_COLOR = '#FFFFFF';
const DARK_CONTRAST_COLOR = '#000000';

/**
 * Test color definitions with contrast borders for selected state.
 * Each color includes a pre-computed contrastColor that ensures
 * visibility when the swatch is selected, avoiding runtime calculations.
 */
export const TEST_COLORS = [
  { name: 'Red', hex: '#FF0000', key: '1', contrastColor: LIGHT_CONTRAST_COLOR },
  { name: 'Green', hex: '#00FF00', key: '2', contrastColor: DARK_CONTRAST_COLOR },
  { name: 'Blue', hex: '#0000FF', key: '3', contrastColor: LIGHT_CONTRAST_COLOR },
  { name: 'Cyan', hex: '#00FFFF', key: '4', contrastColor: DARK_CONTRAST_COLOR },
  { name: 'Magenta', hex: '#FF00FF', key: '5', contrastColor: LIGHT_CONTRAST_COLOR },
  { name: 'Yellow', hex: '#FFFF00', key: '6', contrastColor: DARK_CONTRAST_COLOR },
  { name: 'Black', hex: '#000000', key: '7', contrastColor: LIGHT_CONTRAST_COLOR },
  { name: 'White', hex: '#FFFFFF', key: '8', contrastColor: DARK_CONTRAST_COLOR },
] as const;

/** Single test color from the palette */
export type TestColor = (typeof TEST_COLORS)[number];

/** Color name literal type */
export type ColorName = TestColor['name'];

/** Valid color index (0-7) */
export type ColorIndex = 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7;

/** Total number of test colors */
export const COLOR_COUNT = TEST_COLORS.length;
