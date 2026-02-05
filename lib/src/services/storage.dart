// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:convert';

import 'package:web/web.dart';

/// Wraps localStorage with graceful fallback for private browsing.
class StorageService {
  static const _prefix = 'injuredpixels_';

  /// Reads a value from localStorage.
  /// Returns null if the key doesn't exist or storage is unavailable.
  T? read<T>(String key) {
    try {
      final value = window.localStorage.getItem('$_prefix$key');
      if (value == null) return null;

      // Handle primitive types
      if (T == int) return int.tryParse(value) as T?;
      if (T == double) return double.tryParse(value) as T?;
      if (T == bool) return (value == 'true') as T;
      if (T == String) return value as T;

      // Handle JSON for complex types
      return jsonDecode(value) as T?;
    } catch (_) {
      // Storage unavailable (private browsing) or parse error
      return null;
    }
  }

  /// Writes a value to localStorage.
  /// Silently fails if storage is unavailable.
  void write<T>(String key, T value) {
    try {
      String stringValue;

      // Handle primitive types
      if (value is int || value is double || value is bool) {
        stringValue = value.toString();
      } else if (value is String) {
        stringValue = value;
      } else {
        // Handle complex types as JSON
        stringValue = jsonEncode(value);
      }

      window.localStorage.setItem('$_prefix$key', stringValue);
    } catch (_) {
      // Storage unavailable (private browsing) - silently fail
    }
  }

  /// Removes a value from localStorage.
  void remove(String key) {
    try {
      window.localStorage.removeItem('$_prefix$key');
    } catch (_) {
      // Storage unavailable - silently fail
    }
  }
}
