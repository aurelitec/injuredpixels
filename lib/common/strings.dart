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
// Home Screen (Test Screen)
// -----------------------------------------------------------------------------------------------

// const String helpMenuItem = 'Online Help';
// const String supportMenuItem = 'Contact Support';
// const String rateAppMenuItem = 'Rate App';

// -----------------------------------------------------------------------------------------------
// Test Screen
// -----------------------------------------------------------------------------------------------

// const String inspectModeTooltip = 'Enter inspection mode';

String testScreenTip(bool mouseIsConnected) =>
    '<b>Long ${mouseIsConnected ? 'click' : 'tap'}</b> the color screen or press <b>Space</b> to enter and exit inspection mode. <b>Double ${mouseIsConnected ? 'click' : 'tap'}</b> the color screen or use <b>arrow keys</b> to cycle through colors. ';
