// This file is part of InjuredPixels (https://www.aurelitec.com/injuredpixels/).
// Copyright 2016-2024 Aurelitec. All rights reserved.
// See the LICENSE file in the project root for license information.
// @author TechAurelian <dev@techaurelian.com> (https://techaurelian.com)

import 'package:flutter/material.dart';

/// Returns the theme for the app.
ThemeData getAppTheme(Brightness brightness) {
  final Color contrastColor = brightness == Brightness.light ? Colors.black : Colors.white;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: BorderSide(color: contrastColor),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: contrastColor,
    ),
    // appBarTheme: const AppBarTheme(
    //   actionsIconTheme: IconThemeData(
    //     size: 32.0,
    //   ),
    // ),
  );
}
