// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

/// Wraps localStorage with type-specific accessors.
///
/// Methods throw on storage unavailability (e.g. private browsing) or parse errors. Callers decide
/// error handling policy.
library;

import 'package:web/web.dart';

const _prefix = 'injuredpixels_';

/// Reads an integer from localStorage.
///
/// Returns `null` if the key doesn't exist. Throws [FormatException] if the stored value is not a
/// valid integer. Throws if storage is unavailable.
int? getInt(String key) {
  final value = window.localStorage.getItem('$_prefix$key');
  if (value == null) return null;
  return int.parse(value);
}

/// Writes an integer to localStorage.
///
/// Throws if storage is unavailable.
void setInt(String key, int value) {
  window.localStorage.setItem('$_prefix$key', value.toString());
}
