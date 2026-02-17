// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

import 'dart:io';

/// A file or directory to copy from the intermediate build to the output directory.
sealed class BuildEntry {
  /// Source path relative to the intermediate build directory.
  final String source;

  /// Target path relative to the output directory. Defaults to [source].
  final String target;

  const BuildEntry(this.source, {String? target}) : target = target ?? source;
}

/// A single file to copy.
class BuildFile extends BuildEntry {
  const BuildFile(super.source, {super.target});
}

/// A directory to copy recursively.
class BuildDirectory extends BuildEntry {
  const BuildDirectory(super.source, {super.target});
}

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

/// Copies build entries from [buildDir] to [outputDir] based on [BuildEntry] mappings.
///
/// Handles both files and directories. Creates subdirectories in [outputDir] as needed.
Future<void> copyBuildEntries(
  String buildDir,
  String outputDir,
  List<BuildEntry> entries,
) async {
  for (final e in entries) {
    final sourcePath = '$buildDir/${e.source}';
    final targetPath = '$outputDir/${e.target}';
    switch (e) {
      case BuildFile():
        await Directory(File(targetPath).parent.path).create(recursive: true);
        await File(sourcePath).copy(targetPath);
      case BuildDirectory():
        await copyDirectory(Directory(sourcePath), Directory(targetPath));
    }
  }
}

/// Minifies an HTML file in place using the `minify` CLI.
Future<void> minifyHtml(String path) async {
  await run('minify', ['-o', path, path]);
}

/// Minifies a JavaScript file in place using the `minify` CLI.
Future<void> minifyJs(String path) async {
  await run('minify', ['-o', path, path]);
}

/// Strips `<!-- name:start -->` to `<!-- name:end -->` blocks from a file.
Future<void> stripConditionalBlocks(String path, String name) async {
  final file = File(path);
  final content = await file.readAsString();
  final stripped = content.replaceAll(
    RegExp(
      r'[ \t]*<!--\s*' +
          RegExp.escape(name) +
          r':start\s*-->.*?<!--\s*' +
          RegExp.escape(name) +
          r':end\s*-->\n?',
      dotAll: true,
    ),
    '',
  );
  await file.writeAsString(stripped);
}

/// Recursively copies the contents of a directory.
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
