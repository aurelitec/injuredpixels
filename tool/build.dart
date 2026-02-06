// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:io';

import 'run.dart';

/// Build the web app for production.
Future<void> main() async {
  print('Building for production...\n');

  // Build the web app
  await run('webdev', ['build']);

  // Build the Tailwind CSS for production (minified)
  await run(
    'tailwindcss',
    ['-i', 'web/input.css', '-o', 'build/style.css', '--minify'],
  );

  // Minify the HTML
  await run('minify', ['-o', 'build/index.html', 'build/index.html']);

  // Delete the input Tailwind CSS file from build output
  final inputCss = File('build/input.css');
  if (await inputCss.exists()) {
    await inputCss.delete();
  }

  print('\n✅ Build complete: build/');
}
