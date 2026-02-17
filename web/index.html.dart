// Copyright (c) 2009-2026 Aurelitec. All rights reserved.
// https://www.aurelitec.com/injuredpixels/
// Licensed under the MIT License.

// TODO: "dart run tool/dev.dart" still loads the service worker in dev mode, which causes caching issues. Fix this by adding a "dev" flag and conditionally loading the service worker script?

/// HTML template for InjuredPixels. Generates target-specific HTML (web or portable).
String indexHtml({required String target}) =>
    '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Detect dead, stuck, or hot pixels on LCD/OLED displays by filling the screen with solid colors.">
  <meta name="theme-color" content="#000000">
  <title>InjuredPixels</title>
${target == 'web' ? '''
  <link rel="icon" type="image/png" sizes="96x96" href="icons/favicon-96x96.png">
  <link rel="shortcut icon" href="favicon.ico">
  <link rel="apple-touch-icon" sizes="180x180" href="icons/apple-touch-icon.png">
  <link rel="manifest" href="manifest.json">
  <link rel="stylesheet" href="style.css">
  <script defer src="main.dart.js"></script>
  <script>
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker.register('sw.js');
    }
  </script>''' : '''
  <link rel="icon" type="image/png" sizes="96x96" href="assets/favicon-96x96.png">
  <link rel="stylesheet" href="assets/style.css">
  <script defer src="assets/main.dart.js"></script>'''}
</head>
<body class="flex min-h-screen items-center justify-center select-none" style="background-color: rgb(255, 0, 0);">

  <!--------------------------------------------------------------------------
    App Icons SVG Sprite
  --------------------------------------------------------------------------->

  <svg style="display: none;">
    <!-- Arrow Circle Left - Material Symbols Outlined -->
    <!-- https://fonts.google.com/icons?selected=Material+Symbols+Outlined:arrow_circle_left:FILL@1;wght@400;GRAD@0;opsz@24&icon.query=left&icon.size=24&icon.color=%231f1f1f&icon.style=Outlined -->
    <symbol id="icon-left" viewBox="0 -960 960 960" fill="currentColor">
      <path d="m480-320 56-56-64-64h168v-80H472l64-64-56-56-160 160 160 160Zm0 240q-83 0-156-31.5T197-197q-54-54-85.5-127T80-480q0-83 31.5-156T197-763q54-54 127-85.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 83-31.5 156T763-197q-54 54-127 85.5T480-80Z"/>
    </symbol>

    <!-- Arrow Circle Right - Material Symbols Outlined -->
    <!-- https://fonts.google.com/icons?selected=Material+Symbols+Outlined:arrow_circle_right:FILL@1;wght@400;GRAD@0;opsz@24&icon.query=right&icon.size=24&icon.color=%231f1f1f&icon.style=Outlined -->
    <symbol id="icon-right" viewBox="0 -960 960 960" fill="currentColor">
      <path d="m480-320 160-160-160-160-56 56 64 64H320v80h168l-64 64 56 56Zm0 240q-83 0-156-31.5T197-197q-54-54-85.5-127T80-480q0-83 31.5-156T197-763q54-54 127-85.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 83-31.5 156T763-197q-54 54-127 85.5T480-80Z"/>
    </symbol>

    <!-- Frame Inspect - Material Symbols Outlined -->
    <!-- https://fonts.google.com/icons?selected=Material+Symbols+Outlined:frame_inspect:FILL@1;wght@400;GRAD@0;opsz@24&icon.query=inspect&icon.size=24&icon.color=%231f1f1f&icon.style=Outlined -->
    <symbol id="icon-inspect" viewBox="0 -960 960 960" fill="currentColor">
      <path d="M514-446q26-26 26-64t-26-64q-26-26-64-26t-64 26q-26 26-26 64t26 64q26 26 64 26t64-26Zm129 186L538-365q-20 13-42.5 19t-45.5 6q-71 0-120.5-49.5T280-510q0-71 49.5-120.5T450-680q71 0 120.5 49.5T620-510q0 23-6.5 45.5T594-422l106 106-57 56ZM200-120q-33 0-56.5-23.5T120-200v-160h80v160h160v80H200Zm400 0v-80h160v-160h80v160q0 33-23.5 56.5T760-120H600ZM120-600v-160q0-33 23.5-56.5T200-840h160v80H200v160h-80Zm640 0v-160H600v-80h160q33 0 56.5 23.5T840-760v160h-80Z"/>
    </symbol>

    <!-- Fullscreen - Material Symbols Outlined -->
    <!-- https://fonts.google.com/icons?selected=Material+Symbols+Outlined:fullscreen:FILL@1;wght@400;GRAD@0;opsz@24&icon.query=fullscreen&icon.size=24&icon.color=%231f1f1f&icon.style=Outlined  -->
    <symbol id="icon-enter-fullscreen" viewBox="0 -960 960 960" fill="currentColor">
      <path d="M120-120v-200h80v120h120v80H120Zm520 0v-80h120v-120h80v200H640ZM120-640v-200h200v80H200v120h-80Zm640 0v-120H640v-80h200v200h-80Z"/>
    </symbol>

    <!-- Fullscreen Exit - Material Symbols Outlined -->
    <!-- https://fonts.google.com/icons?selected=Material+Symbols+Outlined:fullscreen_exit:FILL@1;wght@400;GRAD@0;opsz@24&icon.query=fullscreen&icon.size=24&icon.color=%231f1f1f&icon.style=Outlined -->
    <symbol id="icon-exit-fullscreen" viewBox="0 -960 960 960" fill="currentColor">
      <path d="M240-120v-120H120v-80h200v200h-80Zm400 0v-200h200v80H720v120h-80ZM120-640v-80h120v-120h80v200H120Zm520 0v-200h80v120h120v80H640Z"/>
    </symbol>

    <!-- Help - Material Symbols Outlined -->
    <!-- https://fonts.google.com/icons?selected=Material+Symbols+Outlined:help:FILL@1;wght@400;GRAD@0;opsz@24&icon.query=help&icon.size=24&icon.color=%231f1f1f&icon.style=Outlined -->
    <symbol id="icon-help" viewBox="0 -960 960 960" fill="currentColor">
      <path d="M478-240q21 0 35.5-14.5T528-290q0-21-14.5-35.5T478-340q-21 0-35.5 14.5T428-290q0 21 14.5 35.5T478-240Zm-36-154h74q0-33 7.5-52t42.5-52q26-26 41-49.5t15-56.5q0-56-41-86t-97-30q-57 0-92.5 30T342-618l66 26q5-18 22.5-39t53.5-21q32 0 48 17.5t16 38.5q0 20-12 37.5T506-526q-44 39-54 59t-10 73Zm38 314q-83 0-156-31.5T197-197q-54-54-85.5-127T80-480q0-83 31.5-156T197-763q54-54 127-85.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 83-31.5 156T763-197q-54 54-127 85.5T480-80Z"/>
    </symbol>

    <!-- Close - Material Symbols Outlined -->
    <!-- https://fonts.google.com/icons?selected=Material+Symbols+Outlined:close:FILL@1;wght@400;GRAD@0;opsz@24&icon.query=close&icon.size=24&icon.color=%231f1f1f&icon.style=Outlined -->
    <symbol id="icon-close" viewBox="0 -960 960 960" fill="currentColor">
      <path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/>
    </symbol>

    <!-- East-Tec Logo Shield Icon -->
    <symbol id="icon-east-tec" viewBox="0 0 2048 2048" fill="currentColor">
      <path d="M1651.82 1430.633c0-927.523-590.353-1419.017-1299.193-1427.564 28.522-2.065 57.247-3.07 86.33-3.07 693.45 0 1256.416 594.29 1256.416 1326.378 0 266.093-74.3 513.888-202.194 721.623 105.905-206.955 158.64-395.143 158.64-617.367m-762.565 411.08-.24-350.846-3.887.118c-36.392.112-65.802-29.216-65.802-65.507l.461-114.3-3.31-2.826c-19.945-19.062-32.381-45.957-32.381-75.786 0-57.777 46.909-104.62 104.646-104.7l-.118-200.963c145.26-1.05 289.969 12.872 432.306 86.43-22.097 345.506-160.909 616.404-431.675 828.38m-252.894-220.776c-33.108-40.318-63.663-82.667-91.209-126.975-47.741-76.784-86.261-159.167-114.18-245.179-19.704-60.7-34.18-122.882-43.482-186.008a1198 1198 0 0 1-7.69-64.368c-1.474-16.025-2.506-32.058-3.662-48.111 13.371-6.82 26.657-13.81 40.183-20.327a1048 1048 0 0 1 49.388-22.217 941 941 0 0 1 32.732-12.976c4.05-192.499 161.594-347.61 354.99-347.61 195.046 0 353.649 157.664 355.114 352.412 20.23 8.42 40.14 17.622 59.616 27.643a804 804 0 0 1 74.524 43.551c10.914 7.193 21.603 14.717 32.153 22.432-8.932-5.395-17.941-10.67-27.073-15.715-25.418-14.031-51.662-26.748-78.474-37.889-28.628-11.894-57.9-22.288-87.675-30.933-16.87-4.899-33.848-9.342-50.977-13.254-150.132-34.266-309.613-30.257-459.25 4.64a1118 1118 0 0 0-84.35 23.173c-43.344 13.761-85.825 30.256-127.07 49.405l-23.682 11.619 2.51 29.258c4.979 48.269 12.51 96.257 22.859 143.7 14.84 68.059 35.227 134.532 61.247 199.15 36.458 90.557 84.001 176.38 140.45 255.989 59.142 83.41 128.082 159.87 203.579 228.753-84.73-64.71-162.853-137.696-230.571-220.163m248.288-158.634 7.213-.215c20.625-.04 37.436-16.888 37.436-37.355l.533-127.517 5.53-4.283c18.033-13.97 29.655-35.732 29.655-60.367 0-41.953-34.115-76.021-76.12-76.021-42.004 0-76.118 34.068-76.118 76.021 0 24.764 11.762 46.715 30.058 60.631l5.688 4.328-.51 128.005c0 20.387 16.534 36.836 36.635 36.773M853.43 631.72c-137.157 0-250.746 102.452-268.248 234.985a1003 1003 0 0 1 54.442-13.351c127.238-27.434 260.371-30.595 388.48-6.996 28.371 5.223 56.37 11.812 84.132 19.647 3.264.918 6.528 1.865 9.783 2.826C1105.44 735.319 991.39 631.72 853.431 631.72"/>
    </symbol>

    <!-- GitHub - Simple Icons -->
    <!-- https://simpleicons.org/?q=github -->
    <symbol id="icon-github" viewBox="0 0 24 24" fill="currentColor">
      <path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/>
    </symbol>
  </svg>

  <!--------------------------------------------------------------------------
    Control Panel
  --------------------------------------------------------------------------->

  <div id="control-panel" class="control-panel" role="toolbar" aria-label="Control panel">

    <!-- Color swatches grid -->
    <div id="swatches" class="grid grid-cols-4 justify-items-center gap-2 rounded-t-panel bg-panel-swatch p-3 sm:gap-swatch-gap sm:p-panel-padding md:grid-cols-8">
      <button class="color-swatch selected bg-[#FF0000] text-[#FFFFFF]">
        <span class="color-swatch-label">Red</span>
      </button>
      <button class="color-swatch bg-[#00FF00] text-[#000000]">
        <span class="color-swatch-label">Green</span>
      </button>
      <button class="color-swatch bg-[#0000FF] text-[#FFFFFF]">
        <span class="color-swatch-label">Blue</span>
      </button>
      <button class="color-swatch bg-[#00FFFF] text-[#000000]">
        <span class="color-swatch-label">Cyan</span>
      </button>
      <button class="color-swatch bg-[#FF00FF] text-[#FFFFFF]">
        <span class="color-swatch-label">Magenta</span>
      </button>
      <button class="color-swatch bg-[#FFFF00] text-[#000000]">
        <span class="color-swatch-label">Yellow</span>
      </button>
      <button class="color-swatch bg-[#000000] text-[#FFFFFF]">
        <span class="color-swatch-label">Black</span>
      </button>
      <button class="color-swatch bg-[#FFFFFF] text-[#000000]">
        <span class="color-swatch-label">White</span>
      </button>
    </div>

    <!-- Action toolbar -->
    <div class="flex flex-wrap items-center justify-center gap-x-4 gap-y-1 rounded-b-panel bg-panel-toolbar px-6 py-2">
      <button data-action="previous" class="toolbar-btn">
        <svg class="toolbar-btn-icon" width="1em" height="1em"><use href="#icon-left"/></svg>
        <span class="toolbar-btn-label">Previous</span>
      </button>
      <button data-action="next" class="toolbar-btn">
        <svg class="toolbar-btn-icon" width="1em" height="1em"><use href="#icon-right"/></svg>
        <span class="toolbar-btn-label">Next</span>
      </button>
      <button data-action="inspect" class="toolbar-btn">
        <svg class="toolbar-btn-icon" width="1em" height="1em"><use href="#icon-inspect"/></svg>
        <span class="toolbar-btn-label">Inspect</span>
      </button>
      <button data-action="fullscreen" class="toolbar-btn" aria-label="Toggle fullscreen">
        <svg class="toolbar-btn-icon inline [*:fullscreen_&]:hidden" width="1em" height="1em"><use href="#icon-enter-fullscreen"/></svg>
        <svg class="toolbar-btn-icon hidden [*:fullscreen_&]:inline" width="1em" height="1em"><use href="#icon-exit-fullscreen"/></svg>
        <span class="toolbar-btn-label">Fullscreen</span>
      </button>
      <button data-action="help" class="toolbar-btn lg:mr-auto">
        <svg class="toolbar-btn-icon" width="1em" height="1em"><use href="#icon-help"/></svg>
        <span class="toolbar-btn-label">Help</span>
      </button>
      <a href="https://www.east-tec.com/aurelitec/?utm_source=aurelitec&utm_medium=sponsor&utm_campaign=injuredpixels-app" target="_blank" rel="noopener noreferrer" class="toolbar-btn md:ml-auto">
        <svg class="toolbar-btn-icon scale-125 md:scale-150" width="1em" height="1em"><use href="#icon-east-tec"/></svg>
        <span class="toolbar-btn-label md:flex md:flex-col md:-my-2">
          <small class="text-[0.5rem]">Sponsored by</small>
          <span>East-Tec</span>
        </span>
      </a>
    </div>

  </div>

  <!--------------------------------------------------------------------------
    Help Dialog (native <dialog> with ::backdrop)
  --------------------------------------------------------------------------->

  <dialog id="help-dialog" class="help-dialog" closedby="any" aria-label="Help">

    <!-- Dark header -->
    <div class="flex items-center justify-between rounded-t-panel bg-panel-toolbar px-6 py-4 select-none">
      <h2 class="text-base font-semibold text-toolbar-text">Help</h2>
      <button data-action="close" class="rounded p-1.5 transition-colors hover:bg-toolbar-hover" aria-label="Close">
        <svg class="h-5 w-5 text-toolbar-text"><use href="#icon-close"/></svg>
      </button>
    </div>

    <!-- Light body — shortcuts -->
    <div class="rounded-b-panel bg-help-dialog-bg px-6 py-5">
      <dl class="space-y-1.5 text-sm">
        <h3 class="shortcut-section">Keyboard</h3>
        <div class="shortcut-row"><dt class="shortcut-key">1-8</dt><dd class="shortcut-desc">Jump to color</dd></div>
        <div class="shortcut-row"><dt class="shortcut-key">← →</dt><dd class="shortcut-desc">Cycle colors</dd></div>
        <div class="shortcut-row"><dt class="shortcut-key">F</dt><dd class="shortcut-desc">Enter/exit fullscreen</dd></div>
        <div class="shortcut-row"><dt class="shortcut-key">Space</dt><dd class="shortcut-desc">Hide/show controls</dd></div>
        <div class="shortcut-row"><dt class="shortcut-key">Esc</dt><dd class="shortcut-desc">Show controls</dd></div>
        <div class="shortcut-row"><dt class="shortcut-key">?</dt><dd class="shortcut-desc">Show/hide help</dd></div>

        <h3 class="shortcut-section">Mouse</h3>
        <div class="shortcut-row"><dt class="shortcut-key">Double-click</dt><dd class="shortcut-desc">Next color</dd></div>
        <div class="shortcut-row"><dt class="shortcut-key">Right-click</dt><dd class="shortcut-desc">Hide/show controls</dd></div>

        <h3 class="shortcut-section">Touch</h3>
        <div class="shortcut-row"><dt class="shortcut-key">Double-tap</dt><dd class="shortcut-desc">Next color</dd></div>
        <div class="shortcut-row"><dt class="shortcut-key">Touch and hold</dt><dd class="shortcut-desc">Hide/show controls</dd></div>
      </dl>

      <!-- About footer -->
      <div class="mt-5 flex justify-between gap-4 border-t border-gray-300 pt-4 text-xs text-gray-500">
        <div class="space-y-1.5">
          <p class="font-semibold text-gray-700">InjuredPixels 5.0.0</p>
          <p class="mt-0.5">© 2009-2026 Aurelitec</p>
        </div>
        <div class="flex flex-col items-end gap-1">
          <a href="https://www.aurelitec.com/injuredpixels/" target="_blank" rel="noopener noreferrer" class="text-gray-500 underline transition-colors hover:text-gray-700">
            aurelitec.com
          </a>
          <a href="https://github.com/aurelitec/injuredpixels" target="_blank" rel="noopener noreferrer" class="inline-flex items-center gap-1 text-gray-500 transition-colors hover:text-gray-700">
            <svg class="h-3.5 w-3.5"><use href="#icon-github"/></svg>
            Star on GitHub
          </a>
        </div>
      </div>
    </div>

  </dialog>

  <!--------------------------------------------------------------------------
    TOAST (popover)
  --------------------------------------------------------------------------->

  <div id="toast" class="toast" popover="manual" role="status" aria-live="polite" data-msg-hide-hint="Press Space or Escape, right-click, or touch and hold to show controls">
    <span class="text-sm" data-message></span>
    <button data-action="dismiss" class="shrink-0 rounded p-1 transition-colors hover:bg-white/10" aria-label="Dismiss">
      <svg class="h-4 w-4"><use href="#icon-close"/></svg>
    </button>
  </div>

</body>
</html>
''';
