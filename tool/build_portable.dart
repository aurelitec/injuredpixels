// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:io';

import 'run.dart';

/// Output directory for the portable build.
const _outputDir = 'build-portable';

/// Files to copy from the webdev build output to the portable build.
const _webdevFiles = ['index.html', 'main.dart.js'];

/// Files to copy from the web source directory to the portable build.
const _webFiles = ['favicon.ico'];

/// Directory containing static files to copy to the portable build.
const _staticDir = 'static-portable';

/// Build the portable web app for distribution as a ZIP archive.
Future<void> main() async {
  print('Building portable...\n');

  // Build the web app (reuses webdev build output)
  await run('webdev', ['build']);

  // Prepare the output directory
  final outputDir = Directory(_outputDir);
  if (await outputDir.exists()) await outputDir.delete(recursive: true);
  await outputDir.create();

  // Copy whitelisted files from webdev build output
  for (final name in _webdevFiles) {
    await File('build/$name').copy('$_outputDir/$name');
  }

  // Copy whitelisted files from web source directory
  for (final name in _webFiles) {
    await File('web/$name').copy('$_outputDir/$name');
  }

  // Build the Tailwind CSS for production (minified)
  await run(
    'tailwindcss',
    ['-i', 'web/input.css', '-o', '$_outputDir/style.css', '--minify'],
  );

  // Minify the HTML
  await run('minify', ['-o', '$_outputDir/index.html', '$_outputDir/index.html']);

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
