/**
 * Copyright (c) 2009-2026 Aurelitec
 * https://www.aurelitec.com/injuredpixels/
 * Licensed under the MIT License. See LICENSE file in the project root.
 */

import { useState, useEffect, useCallback } from 'react';

/**
 * Hook that syncs state with localStorage.
 * Gracefully handles unavailable localStorage (private browsing, quota exceeded).
 *
 * @param key - localStorage key
 * @param initialValue - fallback value if no stored value exists
 * @returns tuple of [storedValue, setValue]
 */
export function useLocalStorage<T>(
  key: string,
  initialValue: T
): [T, (value: T | ((prev: T) => T)) => void] {
  // Lazy initializer: read from localStorage on first render only
  const [storedValue, setStoredValue] = useState<T>(() => {
    try {
      const item = localStorage.getItem(key);
      return item !== null ? (JSON.parse(item) as T) : initialValue;
    } catch {
      // localStorage unavailable or JSON parse error
      return initialValue;
    }
  });

  // Persist to localStorage when value changes
  useEffect(() => {
    try {
      localStorage.setItem(key, JSON.stringify(storedValue));
    } catch {
      // Silently fail: quota exceeded or localStorage unavailable
    }
  }, [key, storedValue]);

  // Wrapper that supports functional updates
  const setValue = useCallback((value: T | ((prev: T) => T)) => {
    setStoredValue((prev) => (value instanceof Function ? value(prev) : value));
  }, []);

  return [storedValue, setValue];
}
