// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:io';

import 'build_utils.dart';

/// Output directory for the portable build.
const _outputDir = 'build-portable';

/// Files to copy from the intermediate build output.
const _buildFiles = ['index.html', 'main.dart.js', 'style.css', 'favicon.ico', 'favicon-96x96.png'];

/// Directory containing static files to copy to the portable build.
const _staticDir = 'static-portable';

/// Build the portable web app for distribution as a ZIP archive.
Future<void> main() async {
  print('Building portable...\n');

  // Run the intermediate build (webdev + tailwindcss + minify)
  await run('dart', ['run', 'tool/build.dart']);

  // Prepare the output directory
  await prepareOutputDir(_outputDir);

  // Copy whitelisted files from the intermediate build
  for (final name in _buildFiles) {
    await File('build/$name').copy('$_outputDir/$name');
  }

  // Strip web-only blocks and minify the HTML
  await stripWebOnlyBlocks('$_outputDir/index.html');
  await minifyHtml('$_outputDir/index.html');

  // Copy all static portable files
  await copyDirectory(Directory(_staticDir), Directory(_outputDir));

  print('\n✅ Portable build complete: $_outputDir/');
}
