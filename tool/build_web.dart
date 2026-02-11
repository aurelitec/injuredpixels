// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'build_utils.dart';

/// Output directory for the web/PWA build.
const _outputDir = 'build-web';

/// Entries to copy from the intermediate build output.
const _buildEntries = <BuildEntry>[
  BuildFile('index.html'),
  BuildFile('main.dart.js'),
  BuildFile('style.css'),
  BuildFile('favicon.ico'),
  BuildFile('manifest.json'),
  BuildDirectory('icons'),
];

/// Build the web app/PWA for deployment.
Future<void> main() async {
  print('Building web...\n');

  // Run the intermediate build (webdev + tailwindcss + minify)
  await run('dart', ['run', 'tool/build.dart']);

  // Prepare the output directory
  await prepareOutputDir(_outputDir);

  // Copy whitelisted entries from the intermediate build
  await copyBuildEntries('build', _outputDir, _buildEntries);

  // Strip portable-only blocks and minify the HTML
  await stripConditionalBlocks('$_outputDir/index.html', 'portable-only');
  await minifyHtml('$_outputDir/index.html');

  print('\n✅ Web build complete: $_outputDir/');
}
