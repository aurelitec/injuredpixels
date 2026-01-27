/**
 * Test color definitions with contrast borders for selected state.
 * Each color includes a pre-computed contrastBorder that ensures
 * visibility when the swatch is selected, avoiding runtime calculations.
 */
export const TEST_COLORS = [
  { name: 'Red', hex: '#FF0000', key: '1', contrastBorder: '#FFFFFF' },
  { name: 'Green', hex: '#00FF00', key: '2', contrastBorder: '#333333' },
  { name: 'Blue', hex: '#0000FF', key: '3', contrastBorder: '#FFFFFF' },
  { name: 'Cyan', hex: '#00FFFF', key: '4', contrastBorder: '#333333' },
  { name: 'Magenta', hex: '#FF00FF', key: '5', contrastBorder: '#FFFFFF' },
  { name: 'Yellow', hex: '#FFFF00', key: '6', contrastBorder: '#333333' },
  { name: 'Black', hex: '#000000', key: '7', contrastBorder: '#FFFFFF' },
  { name: 'White', hex: '#FFFFFF', key: '8', contrastBorder: '#333333' },
] as const;

/** Single test color from the palette */
export type TestColor = (typeof TEST_COLORS)[number];

/** Color name literal type */
export type ColorName = TestColor['name'];

/** Valid color index (0-7) */
export type ColorIndex = 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7;

/** Total number of test colors */
export const COLOR_COUNT = TEST_COLORS.length;
