// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:io';

import 'run.dart';

/// Output directory for the portable build.
const _outputDir = 'build-portable';

/// Files to copy from the web build output to the portable build.
const _buildFiles = ['index.html', 'main.dart.js', 'style.css', 'favicon.ico', 'favicon-96x96.png'];

/// Directory containing static files to copy to the portable build.
const _staticDir = 'static-portable';

/// Build the portable web app for distribution as a ZIP archive.
Future<void> main() async {
  print('Building portable...\n');

  // Run the full web build first (webdev + tailwindcss + minify)
  await run('dart', ['run', 'tool/build.dart']);

  // Prepare the output directory
  final outputDir = Directory(_outputDir);
  if (await outputDir.exists()) await outputDir.delete(recursive: true);
  await outputDir.create();

  // Copy whitelisted files from the web build (already minified/optimized)
  for (final name in _buildFiles) {
    await File('build/$name').copy('$_outputDir/$name');
  }

  // Copy all static portable files
  final staticDir = Directory(_staticDir);
  if (await staticDir.exists()) {
    await for (final entity in staticDir.list()) {
      if (entity is File) {
        final name = entity.uri.pathSegments.last;
        await entity.copy('$_outputDir/$name');
      }
    }
  }

  print('\n✅ Portable build complete: $_outputDir/');
}
