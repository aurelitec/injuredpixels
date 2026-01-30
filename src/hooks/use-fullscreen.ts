/**
 * Copyright (c) 2009-2026 Aurelitec
 * https://www.aurelitec.com/injuredpixels/
 * Licensed under the MIT License. See LICENSE file in the project root.
 */

import { useState, useEffect, useCallback, useRef } from 'react';

interface UseFullscreenOptions {
  /** Called when exiting fullscreen (via Escape key or programmatically) */
  onExit?: () => void;
}

interface UseFullscreenReturn {
  isFullscreen: boolean;
  enterFullscreen: () => Promise<void>;
  exitFullscreen: () => Promise<void>;
  toggleFullscreen: () => Promise<void>;
}

/**
 * Hook that wraps the Fullscreen API with React state synchronization.
 * Listens for fullscreenchange events to update state when user exits via Escape.
 */
export function useFullscreen(options?: UseFullscreenOptions): UseFullscreenReturn {
  const [isFullscreen, setIsFullscreen] = useState(() => {
    if (typeof document === 'undefined') return false;
    return document.fullscreenElement !== null;
  });

  // Use ref for callback to avoid re-running effect when callback changes
  const onExitRef = useRef(options?.onExit);
  useEffect(() => {
    onExitRef.current = options?.onExit;
  }, [options?.onExit]);

  // Sync state when fullscreen changes (e.g., user presses Escape)
  useEffect(() => {
    const handleFullscreenChange = () => {
      const isNowFullscreen = document.fullscreenElement !== null;
      setIsFullscreen(isNowFullscreen);

      // Call onExit when exiting fullscreen (fullscreenElement becomes null)
      if (!isNowFullscreen && onExitRef.current) {
        onExitRef.current();
      }
    };

    document.addEventListener('fullscreenchange', handleFullscreenChange);

    return () => {
      document.removeEventListener('fullscreenchange', handleFullscreenChange);
    };
  }, []);

  const enterFullscreen = useCallback(async () => {
    try {
      await document.documentElement.requestFullscreen();
    } catch {
      // Fullscreen request failed (not triggered by user gesture, or not supported)
    }
  }, []);

  const exitFullscreen = useCallback(async () => {
    try {
      if (document.fullscreenElement) {
        await document.exitFullscreen();
      }
    } catch {
      // Exit fullscreen failed
    }
  }, []);

  const toggleFullscreen = useCallback(async () => {
    if (document.fullscreenElement) {
      await exitFullscreen();
    } else {
      await enterFullscreen();
    }
  }, [enterFullscreen, exitFullscreen]);

  return {
    isFullscreen,
    enterFullscreen,
    exitFullscreen,
    toggleFullscreen,
  };
}
