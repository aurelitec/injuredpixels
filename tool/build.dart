// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'build_utils.dart';

/// Intermediate production build: webdev + tailwindcss → build/
Future<void> main() async {
  print('Building intermediate...\n');

  // Clean previous build output
  await prepareOutputDir('build');

  // Compile Dart to JS
  await run('webdev', ['build']);

  // Build the Tailwind CSS for production (minified)
  await run(
    'tailwindcss',
    ['-i', 'web/input.css', '-o', 'build/style.css', '--minify'],
  );

  print('\n✅ Intermediate build complete: build/');
}
