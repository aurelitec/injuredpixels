// This file is part of InjuredPixels (https://www.aurelitec.com/injuredpixels/).
// Copyright 2016-2024 Aurelitec. All rights reserved.
// See the LICENSE file in the project root for license information.
// @author TechAurelian <dev@techaurelian.com> (https://techaurelian.com)

/// Various utilities for working with Material widgets.
library;

import 'package:flutter/material.dart';

/// Parses a string with bold tags and returns a [TextSpan] with the bold parts styled.
///
/// The [data] string should contain the text to parse with `<b>` and `</b>` tags to indicate bold
/// parts. The [style] parameter is the base style to apply to the text.
///
/// Example:
///
/// ```dart
/// parseBoldStyledText(
///   'This is <b>bold</b> text.',
///   style: const TextStyle(fontSize: 16.0),
/// );
/// ```
///
/// This will return a [TextSpan] with the following structure:
///
/// ```dart
/// TextSpan(
///   children: <TextSpan>[
///     TextSpan(text: 'This is ', style: TextStyle(fontSize: 16.0)),
///     TextSpan(text: 'bold', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
///     TextSpan(text: ' text.', style: TextStyle(fontSize: 16.0)),
///   ],
/// );
/// ```
TextSpan parseBoldStyledText(String data, {required TextStyle style}) {
  final List<String> parts = data.split(RegExp(r'<b>|</b>'));
  final List<TextSpan> children = <TextSpan>[];

  for (int i = 0; i < parts.length; i++) {
    if (i % 2 == 0) {
      children.add(TextSpan(text: parts[i], style: style));
    } else {
      children.add(TextSpan(text: parts[i], style: style.copyWith(fontWeight: FontWeight.bold)));
    }
  }

  return TextSpan(children: children);
}
