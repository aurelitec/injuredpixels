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

/// Prepares an output directory: deletes it if it exists, then creates it.
Future<void> prepareOutputDir(String path) async {
  final dir = Directory(path);
  if (await dir.exists()) await dir.delete(recursive: true);
  await dir.create();
}

/// Minifies an HTML file in place using the `minify` CLI.
Future<void> minifyHtml(String path) async {
  await run('minify', ['-o', path, path]);
}

/// Strips `<!-- web-only:start -->` to `<!-- web-only:end -->` blocks from a file.
Future<void> stripWebOnlyBlocks(String path) async {
  final file = File(path);
  final content = await file.readAsString();
  final stripped = content.replaceAll(
    RegExp(r'[ \t]*<!--\s*web-only:start\s*-->.*?<!--\s*web-only:end\s*-->\n?',
        dotAll: true),
    '',
  );
  await file.writeAsString(stripped);
}

/// Recursively copies a directory.
Future<void> copyDirectory(Directory source, Directory target) async {
  await target.create(recursive: true);
  await for (final entity in source.list()) {
    final name = entity.uri.pathSegments.last;
    if (entity is File) {
      await entity.copy('${target.path}/$name');
    } else if (entity is Directory) {
      await copyDirectory(entity, Directory('${target.path}/$name'));
    }
  }
}
