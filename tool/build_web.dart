// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:io';

import 'build_utils.dart';

/// Output directory for the web/PWA build.
const _outputDir = 'build-web';

/// Files to copy from the intermediate build output.
const _buildFiles = [
  BuildFile('index.html'),
  BuildFile('main.dart.js'),
  BuildFile('style.css'),
  BuildFile('favicon.ico'),
  BuildFile('favicon-96x96.png'),
  BuildFile('apple-touch-icon.png'),
  BuildFile('manifest.json'),
];

/// Directories to copy from the intermediate build output.
const _buildDirs = ['icons'];

/// Build the web app/PWA for deployment.
Future<void> main() async {
  print('Building web...\n');

  // Run the intermediate build (webdev + tailwindcss + minify)
  await run('dart', ['run', 'tool/build.dart']);

  // Prepare the output directory
  await prepareOutputDir(_outputDir);

  // Copy whitelisted files from the intermediate build
  await copyBuildFiles('build', _outputDir, _buildFiles);

  // Copy whitelisted directories from the intermediate build
  for (final name in _buildDirs) {
    await copyDirectory(Directory('build/$name'), Directory('$_outputDir/$name'));
  }

  // Strip portable-only blocks and minify the HTML
  await stripConditionalBlocks('$_outputDir/index.html', 'portable-only');
  await minifyHtml('$_outputDir/index.html');

  print('\n✅ Web build complete: $_outputDir/');
}
