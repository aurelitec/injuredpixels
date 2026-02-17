// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:io';

import '../web/index.html.dart';

/// Generates index.html for the specified target.
///
/// Usage: `dart run tool/generate_html.dart <target> <output-path>`
/// Targets: `web`, `portable`
Future<void> main(List<String> args) async {
  if (args.length != 2) {
    stderr.writeln('Usage: dart run tool/generate_html.dart <target> <output-path>');
    exit(1);
  }
  await File(args[1]).writeAsString(indexHtml(target: args[0]));
}
