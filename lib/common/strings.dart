// This file is part of InjuredPixels (https://www.aurelitec.com/injuredpixels/).
// Copyright 2016-2024 Aurelitec. All rights reserved.
// See the LICENSE file in the project root for license information.
// @author TechAurelian <dev@techaurelian.com> (https://techaurelian.com)

/// User interface static string constants.
library;

// -----------------------------------------------------------------------------------------------
// App
// -----------------------------------------------------------------------------------------------

const String appName = 'InjuredPixels';

// -----------------------------------------------------------------------------------------------
// Test Screen (Home Screen)
// -----------------------------------------------------------------------------------------------

const String enterFullScreen = 'Go fullscreen';
const String exitFullScreen = 'Exit fullscreen';

String showTipMenuItem(bool show) => show ? 'Show tip' : 'Hide tip';
const String helpMenuItem = 'Online help';
const String supportMenuItem = 'Contact support';
const String supportUsMenuItem = 'Support us';

// const String inspectModeTooltip = 'Enter inspection mode';

// String testScreenTip(bool mouseIsConnected) =>
//     '<b>Long ${mouseIsConnected ? 'click' : 'tap'}</b> the color screen or press <b>Space</b> to enter and exit inspection mode. <b>Double ${mouseIsConnected ? 'click' : 'tap'}</b> the color screen or use <b>arrow keys</b> to cycle through colors. ';

String testScreenTip(bool mouseIsConnected) =>
    '<b>Long ${mouseIsConnected ? 'click' : 'tap'}</b> the color screen or press <b>Space</b> to toggle inspection mode. <b>Double ${mouseIsConnected ? 'click' : 'tap'}</b> or use <b>arrow keys</b> to cycle colors. <b>Go fullscreen</b> to inspect all pixels.';
