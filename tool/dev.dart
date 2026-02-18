// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'build_utils.dart';

/// Start a development server with live reload and Tailwind CSS watch mode.
Future<void> main() async {
  print('Starting development server...\n');

  // Generate dev-target HTML before starting the server
  await run('dart', ['run', 'tool/generate_html.dart', 'dev', 'web/index.html']);

  // Start webdev serve with auto refresh
  final webdev = await watch('webdev', ['serve', '--auto', 'refresh']);

  // Start Tailwind CSS in watch mode
  final tailwind = await watch(
    'tailwindcss',
    ['-i', 'web/input.css', '-o', 'web/style.css', '--watch'],
  );

  // Keep alive until either process exits
  await Future.any([webdev.exitCode, tailwind.exitCode]);
}
