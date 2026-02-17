// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'build_utils.dart';

/// Intermediate production build: webdev + tailwindcss + minify → build/
Future<void> main() async {
  print('Building intermediate...\n');

  // Clean previous build output
  await prepareOutputDir('build');

  // Generate web-target HTML before compiling
  await run('dart', ['run', 'tool/generate_html.dart', 'web', 'web/index.html']);

  // Compile Dart to JS
  await run('webdev', ['build']);

  // Build the Tailwind CSS for production (minified)
  await run(
    'tailwindcss',
    ['-i', 'web/input.css', '-o', 'build/style.css', '--minify'],
  );

  print('\n✅ Intermediate build complete: build/');
}
