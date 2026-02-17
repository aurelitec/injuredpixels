// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:io';

import 'build_utils.dart';

/// Build artifacts to delete.
const _artifacts = <BuildEntry>[
  BuildDirectory('build'),
  BuildDirectory('build-web'),
  BuildDirectory('build-portable'),
  BuildFile('web/index.html'),
];

/// Clean all build outputs.
Future<void> main() async {
  for (final e in _artifacts) {
    switch (e) {
      case BuildDirectory():
        final dir = Directory(e.source);
        if (await dir.exists()) {
          await dir.delete(recursive: true);
          print('Deleted ${e.source}/');
        }
      case BuildFile():
        final file = File(e.source);
        if (await file.exists()) {
          await file.delete();
          print('Deleted ${e.source}');
        }
    }
  }
  print('\n✅ Clean complete.');
}
