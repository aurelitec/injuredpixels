// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'run.dart';

/// Intermediate production build: webdev + tailwindcss + minify → build/
Future<void> main() async {
  print('Building intermediate...\n');

  // Compile Dart to JS
  await run('webdev', ['build']);

  // Build the Tailwind CSS for production (minified)
  await run(
    'tailwindcss',
    ['-i', 'web/input.css', '-o', 'build/style.css', '--minify'],
  );

  // Minify the HTML
  await run('minify', ['-o', 'build/index.html', 'build/index.html']);

  print('\n✅ Intermediate build complete: build/');
}
