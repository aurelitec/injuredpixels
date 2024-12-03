// This file is part of InjuredPixels (https://www.aurelitec.com/injuredpixels/).
// Copyright 2016-2024 Aurelitec. All rights reserved.
// See the LICENSE file in the project root for license information.
// @author TechAurelian <dev@techaurelian.com> (https://techaurelian.com)

import 'package:flutter/material.dart';

import '../models/test_color.dart';
import '../utils/utils.dart' as utils;

/// The size of each color button in the control panel.
const Size _buttonSize = Size(64.0, 64.0);
const Size _buttonSizeLarge = Size(100.0, 100.0);

/// The screen size enum for the control panel widget.
enum _ScreenSize {
  small,
  medium,
  large,
}

/// The control panel widget for the test screen that displays the color buttons.
class TestControlPanel extends StatelessWidget {
  const TestControlPanel({
    super.key,
    required this.selectedIndex,
    this.onColorButtonPressed,
  });

  /// The index of the selected test color button.
  final int selectedIndex;

  /// The callback that is called when a color button is pressed.
  final void Function(int)? onColorButtonPressed;

  /// A thin wrapper that builds a color button widget for the test control panel.
  Widget _testColorButton(int index, Size size) {
    final Color buttonColor = TestColor.values[index].value;
    final Color? boderColor = TestColor.values[index].name == 'white' ? Colors.black : null;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _TestColorButton(
        color: buttonColor,
        borderColor: boderColor,
        size: size,
        isSelected: index == selectedIndex,
        onPressed: () => onColorButtonPressed?.call(index),
      ),
    );
  }

  /// Builds a row of color buttons for the test control panel.
  Widget _rowOfButtons(int start, int end, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int index = start; index < end; index++) _testColorButton(index, size),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final int testColorCount = TestColor.values.length;

    // Check if the screen is small, medium, or large
    final double width = MediaQuery.of(context).size.width;
    final _ScreenSize screenSize = width < 600.0
        ? _ScreenSize.small
        : width < 1200.0
            ? _ScreenSize.medium
            : _ScreenSize.large;

    // TODO: Fix the layout of the color buttons on very small screens

    // If the screen is large, show all the color buttons in a single row
    if (screenSize == _ScreenSize.large) {
      return _rowOfButtons(0, testColorCount, _buttonSizeLarge);
    }

    // If the screen is small or medium, show the buttons in two rows
    // Use smaller buttons on small screens and larger buttons on medium screens
    final Size buttonSize = screenSize == _ScreenSize.small ? _buttonSize : _buttonSizeLarge;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _rowOfButtons(0, testColorCount ~/ 2, buttonSize),
        _rowOfButtons(testColorCount ~/ 2, testColorCount, buttonSize),
      ],
    );
  }
}

/// A color button widget for the test control panel.
class _TestColorButton extends StatelessWidget {
  const _TestColorButton({
    super.key, // ignore: unused_element
    required this.color,
    this.borderColor,
    this.size,
    this.isSelected = false,
    this.onPressed,
  });

  /// The color of the button.
  final Color color;

  /// The color of the button border.
  final Color? borderColor;

  /// The size of the button.
  final Size? size;

  /// Whether the button is selected.
  final bool isSelected;

  /// The callback that is called when the button is pressed.
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: utils.getContrastColor(color),
        fixedSize: size,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        side: BorderSide(
          color: borderColor ?? Colors.white,
          width: 2.0,
        ),
      ),
      onPressed: onPressed,

      // Add a checkmark icon as the child of the selected color button; otherwise, add an empty box
      child: isSelected ? const Icon(Icons.check, size: 32.0) : const SizedBox.shrink(),
    );
  }
}
