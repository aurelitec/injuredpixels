// This file is part of InjuredPixels (https://www.aurelitec.com/injuredpixels/).
// Copyright 2016-2024 Aurelitec. All rights reserved.
// See the LICENSE file in the project root for license information.
// @author TechAurelian <dev@techaurelian.com> (https://techaurelian.com)

import 'package:flutter/material.dart';

import '../common/preferences.dart' as prefs;
import 'common/strings.dart' as strings;
import 'common/theme.dart';
import 'screens/test_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try to load the app settings from Shared Preferences
  await Future.any([
    prefs.load(),
    Future.delayed(const Duration(seconds: 5)),
  ]);

  runApp(const InjuredPixelsApp());
}

/// The main InjuredPixels application widget.
class InjuredPixelsApp extends StatelessWidget {
  const InjuredPixelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: strings.appName,
      theme: getAppTheme(Brightness.light),
      darkTheme: getAppTheme(Brightness.dark),
      home: const TestScreen(),
    );
  }
}
