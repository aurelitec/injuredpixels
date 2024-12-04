// This file is part of InjuredPixels (https://www.aurelitec.com/injuredpixels/).
// Copyright 2016-2024 Aurelitec. All rights reserved.
// See the LICENSE file in the project root for license information.
// @author TechAurelian <dev@techaurelian.com> (https://techaurelian.com)

import 'package:flutter/material.dart';

import '../common/strings.dart' as strings;
import '../utils/utils.dart' as utils;

/// An on-screen tip widget that displays a lightbulb icon, a text message, and two buttons.
class OnScreenTip extends StatelessWidget {
  const OnScreenTip({
    super.key,
    required this.text,
    this.foregroundColor,
    this.onOkPressed,
    this.onDontShowAgainPressed,
  });

  /// The text to display in the on-screen tip.
  final String text;

  /// The foreground color of the on-screen tip.
  final Color? foregroundColor;

  /// The callback function to call when the OK button is pressed.
  final void Function()? onOkPressed;

  /// The callback function to call when the "Don't show again" button is pressed.
  final void Function()? onDontShowAgainPressed;

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    final TextStyle tipTextStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: foregroundColor,
          fontSize: isLargeScreen ? 20 : 18,
        );

    final ButtonStyle buttonStyle = OutlinedButton.styleFrom(
      foregroundColor: foregroundColor,
      textStyle: tipTextStyle,
      side: BorderSide(color: foregroundColor!),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // The lightbulb (tip) icon
              Icon(
                Icons.lightbulb_outline,
                size: 48,
                color: foregroundColor,
              ),

              const SizedBox(width: 16.0),

              // The tip text
              Flexible(
                child: RichText(
                  softWrap: true,
                  text: utils.parseBoldStyledText(text, style: tipTextStyle),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32.0),

          // The bottom row of buttons
          Row(
            mainAxisAlignment: isLargeScreen ? MainAxisAlignment.end : MainAxisAlignment.center,
            children: <Widget>[
              /// The "Don't show again" button
              OutlinedButton(
                style: buttonStyle,
                onPressed: onDontShowAgainPressed,
                child: const Text(strings.dontShowAgainButton),
              ),

              const SizedBox(width: 16.0),

              /// The "OK" button
              OutlinedButton(
                style: buttonStyle,
                onPressed: onOkPressed,
                child: const Text(strings.okButton),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
