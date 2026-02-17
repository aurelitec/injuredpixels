// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:io';

/// Directories to delete.
const _dirs = ['build', 'build-web', 'build-portable'];

/// Clean all build outputs and tooling cache.
Future<void> main() async {
  for (final name in _dirs) {
    final dir = Directory(name);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
      print('Deleted $name/');
    }
  }
  print('\n✅ Clean complete.');
}
