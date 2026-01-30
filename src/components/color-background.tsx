/**
 * Copyright (c) 2009-2026 Aurelitec
 * https://www.aurelitec.com/injuredpixels/
 * Licensed under the MIT License. See LICENSE file in the project root.
 */

interface ColorBackgroundProps {
  /** Hex color value to fill the viewport */
  color: string;
  /** Called on double-click/double-tap */
  onDoubleClick: () => void;
  /** Called on right-click or long-press (contextmenu event) */
  onContextMenu: () => void;
}

/** Full-screen solid color background for pixel inspection */
export function ColorBackground({
  color,
  onDoubleClick,
  onContextMenu,
}: ColorBackgroundProps) {
  const handleContextMenu = (e: React.MouseEvent) => {
    e.preventDefault();
    onContextMenu();
  };

  return (
    <div
      className="fixed inset-0"
      style={{ backgroundColor: color }}
      onDoubleClick={onDoubleClick}
      onContextMenu={handleContextMenu}
    />
  );
}
