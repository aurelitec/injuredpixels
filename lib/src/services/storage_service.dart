// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:convert';

import 'package:web/web.dart' as web;

/// Service for persistent storage using localStorage.
///
/// Provides graceful fallback when localStorage is unavailable
/// (private browsing, quota exceeded, etc.).
class StorageService {
  static const _keyPrefix = 'injuredpixels_';

  /// Whether localStorage is available.
  final bool _isAvailable;

  StorageService() : _isAvailable = _checkAvailability();

  /// Check if localStorage is available.
  static bool _checkAvailability() {
    try {
      final storage = web.window.localStorage;
      const testKey = '${_keyPrefix}test';
      storage.setItem(testKey, 'test');
      storage.removeItem(testKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Read a value from storage.
  ///
  /// Returns null if the key doesn't exist or storage is unavailable.
  T? read<T>(String key) {
    if (!_isAvailable) return null;

    try {
      final value = web.window.localStorage.getItem('$_keyPrefix$key');
      if (value == null) return null;

      final decoded = jsonDecode(value);
      return decoded as T?;
    } catch (_) {
      return null;
    }
  }

  /// Write a value to storage.
  ///
  /// Silently fails if storage is unavailable.
  void write<T>(String key, T value) {
    if (!_isAvailable) return;

    try {
      final encoded = jsonEncode(value);
      web.window.localStorage.setItem('$_keyPrefix$key', encoded);
    } catch (_) {
      // Silently fail (quota exceeded, etc.)
    }
  }

  /// Remove a value from storage.
  void remove(String key) {
    if (!_isAvailable) return;

    try {
      web.window.localStorage.removeItem('$_keyPrefix$key');
    } catch (_) {
      // Silently fail
    }
  }

  /// Whether storage is available.
  bool get isAvailable => _isAvailable;
}
