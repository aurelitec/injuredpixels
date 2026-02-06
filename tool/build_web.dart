// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:io';

import 'run.dart';

/// Output directory for the web/PWA build.
const _outputDir = 'build-web';

/// Files to copy from the intermediate build output.
const _buildFiles = [
  'index.html',
  'main.dart.js',
  'style.css',
  'favicon.ico',
  'favicon-96x96.png',
  'apple-touch-icon.png',
  'manifest.json',
];

/// Directories to copy from the intermediate build output.
const _buildDirs = ['icons'];

/// Build the web app/PWA for deployment.
Future<void> main() async {
  print('Building web...\n');

  // Run the intermediate build (webdev + tailwindcss + minify)
  await run('dart', ['run', 'tool/build.dart']);

  // Prepare the output directory
  final outputDir = Directory(_outputDir);
  if (await outputDir.exists()) await outputDir.delete(recursive: true);
  await outputDir.create();

  // Copy whitelisted files from the intermediate build
  for (final name in _buildFiles) {
    await File('build/$name').copy('$_outputDir/$name');
  }

  // Copy whitelisted directories from the intermediate build
  for (final name in _buildDirs) {
    await _copyDirectory(Directory('build/$name'), Directory('$_outputDir/$name'));
  }

  print('\n✅ Web build complete: $_outputDir/');
}

/// Recursively copies a directory.
Future<void> _copyDirectory(Directory source, Directory target) async {
  await target.create(recursive: true);
  await for (final entity in source.list()) {
    final name = entity.uri.pathSegments.last;
    if (entity is File) {
      await entity.copy('${target.path}/$name');
    } else if (entity is Directory) {
      await _copyDirectory(entity, Directory('${target.path}/$name'));
    }
  }
}
