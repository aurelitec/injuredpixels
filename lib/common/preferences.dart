// This file is part of InjuredPixels (https://www.aurelitec.com/injuredpixels/).
// Copyright 2016-2024 Aurelitec. All rights reserved.
// See the LICENSE file in the project root for license information.
// @author TechAurelian <dev@techaurelian.com> (https://techaurelian.com)

/// App preferences used to store user settings.
library;

import 'package:shared_preferences/shared_preferences.dart';

import 'package:simple_app_preferences/simple_app_preferences.dart';

/// The app preference for the index of the currently selected test color.
AppPreference<int> testColorIndex = AppPreference<int>(
  defaultValue: 0,
  key: 'testColorIndex',
);

/// The app preference for showing the tip on the test screen.
AppPreference<bool> showTip = AppPreference<bool>(
  defaultValue: true,
  key: 'showTip',
);

/// Loads app settings from persistent storage.
Future<void> load() async {
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    testColorIndex.loadValue(preferences);
    showTip.loadValue(preferences);
  } catch (e) {
    // We can ignore errors here, as the default values will be used.
    // ignore: avoid_print
    print('Error loading preferences: $e');
  }
}
