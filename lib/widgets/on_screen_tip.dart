// This file is part of InjuredPixels (https://www.aurelitec.com/injuredpixels/).
// Copyright 2016-2024 Aurelitec. All rights reserved.
// See the LICENSE file in the project root for license information.
// @author TechAurelian <dev@techaurelian.com> (https://techaurelian.com)

import 'package:flutter/material.dart';

import '../utils/utils.dart' as utils;

class OnScreenTip extends StatelessWidget {
  const OnScreenTip({
    super.key,
    required this.text,
    this.foregroundColor,
  });

  final String text;

  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.lightbulb_outline,
          size: 48,
          color: foregroundColor,
        ),
        const SizedBox(width: 16.0),
        Flexible(
          // fit: FlexFit.loose,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: RichText(
              // textAlign: TextAlign.center,
              softWrap: true,
              text: utils.parseBoldStyledText(
                text,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: foregroundColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
