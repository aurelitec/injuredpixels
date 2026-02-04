// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:io';

/// Run a command and print its output.
Future<void> run(String exe, List<String> args) async {
  print('→ $exe ${args.join(' ')}');
  final result = await Process.run(exe, args);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) exit(result.exitCode);
}

/// Start a process and stream its output.
Future<Process> watch(String exe, List<String> args) async {
  final process = await Process.start(exe, args);
  process.stdout.listen(stdout.add);
  process.stderr.listen(stderr.add);
  return process;
}
