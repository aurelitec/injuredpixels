// This file is part of InjuredPixels (https://www.aurelitec.com/injuredpixels/).
// Copyright 2016-2024 Aurelitec. All rights reserved.
// See the LICENSE file in the project root for license information.
// @author TechAurelian <dev@techaurelian.com> (https://techaurelian.com)

import 'package:flutter/material.dart';

import '../models/test_color.dart';
import '../utils/utils.dart' as utils;

/// The size of each color button in the control panel.
const Size _colorButtonSize = Size(64.0, 64.0);
const Size _colorButtonSizeLarge = Size(100.0, 100.0);

enum _ScreenSize {
  small,
  medium,
  large,
}

/// The control panel widget for the test screen.
///
/// This widget displays a grid of color buttons that can be used to select the test color, as well
/// as an "app bar" with back and hide buttons.
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
    final double width = MediaQuery.of(context).size.width;

    // Check if the screen is small, medium, or large
    final _ScreenSize screenSize = width < 600.0
        ? _ScreenSize.small
        : width < 1200.0
            ? _ScreenSize.medium
            : _ScreenSize.large;

    if (screenSize == _ScreenSize.large) {
      return _rowOfButtons(0, testColorCount, _colorButtonSizeLarge);
    }

    final Size buttonSize =
        screenSize == _ScreenSize.small ? _colorButtonSize : _colorButtonSizeLarge;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Show the first half of the color buttons in the first row and the second half in the second row
        _rowOfButtons(0, testColorCount ~/ 2, buttonSize),
        _rowOfButtons(testColorCount ~/ 2, testColorCount, buttonSize),
      ],
    );

    // final Size buttonSize = isLargeScreen ? _colorButtonSizeLarge : _colorButtonSize;

    // // Show the first half of the color buttons in the first row and the second half in the second row
    // // _rowOfButtons(0, testColorCount ~/ 2),
    // // _rowOfButtons(testColorCount ~/ 2, testColorCount),

    // // _rowOfButtons(0, testColorCount),

    // return isLargeScreen
    //     ? _rowOfButtons(0, testColorCount, buttonSize)
    //     : Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: <Widget>[
    //           // Show the first half of the color buttons in the first row and the second half in the second row
    //           _rowOfButtons(0, testColorCount ~/ 2, buttonSize),
    //           _rowOfButtons(testColorCount ~/ 2, testColorCount, buttonSize),
    //         ],
    //       );

    // // return Padding(
    // //   padding: const EdgeInsets.all(32.0),
    // //   child: Wrap(
    // //     alignment: WrapAlignment.center,
    // //     spacing: 16.0,
    // //     runSpacing: 16.0,
    // //     children: <Widget>[
    // //       for (int index = 0; index < testColorCount; index++)
    // //         _testColorButton(index, isLargeScreen ? _colorButtonSizeLarge : _colorButtonSize),
    // //     ],
    // //   ),
    // // );
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
