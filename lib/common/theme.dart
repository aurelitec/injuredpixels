// This file is part of InjuredPixels (https://www.aurelitec.com/injuredpixels/).
// Copyright 2016-2024 Aurelitec. All rights reserved.
// See the LICENSE file in the project root for license information.
// @author TechAurelian <dev@techaurelian.com> (https://techaurelian.com)

import 'package:flutter/material.dart';

/// Returns the theme for the app.
///
/// Because of the purpose of this app, it's a dark theme that is used for both light and dark mode.
ThemeData getAppTheme() {
  return ThemeData(
    useMaterial3: true,

    // The brightness of the theme is always dark
    brightness: Brightness.dark,

    // The color scheme for the app
    colorScheme: ColorScheme.dark(
      primary: Colors.white,
      surfaceContainerLow: Colors.grey[900],

      // secondary: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.grey[900],

    dividerTheme: DividerThemeData(
      color: Colors.grey[700],
    ),
  );
}
