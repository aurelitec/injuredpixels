// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:io';

import 'build_utils.dart';

/// Output directory for the portable build.
const _outputDir = 'build-portable';

/// Files to copy from the intermediate build output.
const _buildFiles = [
  BuildFile('index.html', target: 'InjuredPixels.html'),
  BuildFile('main.dart.js', target: 'assets/main.dart.js'),
  BuildFile('style.css', target: 'assets/style.css'),
  BuildFile('favicon-96x96.png', target: 'assets/favicon-96x96.png'),
];

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
  await copyBuildFiles('build', _outputDir, _buildFiles);

  // Strip web-only blocks and minify the HTML
  await stripConditionalBlocks('$_outputDir/InjuredPixels.html', 'web-only');
  await minifyHtml('$_outputDir/InjuredPixels.html');

  // Copy all static portable files
  await copyDirectory(Directory(_staticDir), Directory(_outputDir));

  print('\n✅ Portable build complete: $_outputDir/');
}
