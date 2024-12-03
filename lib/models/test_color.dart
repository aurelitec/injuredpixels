// This file is part of InjuredPixels (https://www.aurelitec.com/injuredpixels/).
// Copyright 2016-2024 Aurelitec. All rights reserved.
// See the LICENSE file in the project root for license information.
// @author TechAurelian <dev@techaurelian.com> (https://techaurelian.com)

import 'package:flutter/material.dart';

/// The colors to use for testing the display.
enum TestColor {
  red(Color(0xffff0000)),
  green(Color(0xff00ff00)),
  blue(Color(0xff0000ff)),
  cyan(Color(0xff00ffff)),
  magenta(Color(0xffff00ff)),
  yellow(Color(0xffffff00)),
  black(Color(0xff000000)),
  white(Color(0xffffffff));

  /// Creates a new test color with the given color value.
  const TestColor(this.value);

  /// The color value.
  final Color value;
}
