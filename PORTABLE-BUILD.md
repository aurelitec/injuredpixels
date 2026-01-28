# Portable ZIP Build Configuration

This document explains how the portable ZIP edition of InjuredPixels is built to work on the `file://` protocol without a web server.

## The Problem

Browsers block ES module scripts (`<script type="module">`) when loaded via `file://` protocol due to CORS security restrictions. Vite's default build outputs ES modules, which means the app fails to load when opened directly from the filesystem.

## Solution Overview

We use **app mode with IIFE output format** in Rolldown-Vite. This produces a self-executing JavaScript bundle that doesn't require module loading.

---

## Current Approach: App Mode + IIFE (Recommended for Rolldown-Vite)

This approach works with Rolldown-Vite (tested with v7.2.5) and is simpler than library mode.

### Configuration

```typescript
// vite.config.portable.ts
import { defineConfig, type Plugin } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';

/**
 * Transforms HTML for portable build:
 * - Strips `type="module"` so IIFE bundle loads on file:// protocol
 * - Strips `crossorigin` which triggers CORS even for regular scripts
 * - Adds `defer` so script executes after DOM is ready
 */
function portableHtmlPlugin(): Plugin {
  return {
    name: 'portable-html',
    transformIndexHtml(html) {
      return html
        .replace(/ type="module"/g, '')
        .replace(/ crossorigin/g, '')
        .replace(/<script /g, '<script defer ');
    },
  };
}

export default defineConfig({
  base: './',
  define: {
    'process.env.NODE_ENV': JSON.stringify('production'),
  },
  plugins: [
    react(),
    tailwindcss(),
    portableHtmlPlugin(),
  ],
  build: {
    outDir: 'dist-portable',
    rollupOptions: {
      output: {
        format: 'iife',
        name: 'InjuredPixels',
        inlineDynamicImports: true,
      },
    },
  },
});
```

### Why Each Setting Matters

| Setting | Purpose |
|---------|---------|
| `format: 'iife'` | Outputs IIFE (Immediately Invoked Function Expression) instead of ES module |
| `inlineDynamicImports: true` | **Required** - without this, build fails with "IIFE not supported for code-splitting" |
| `name: 'InjuredPixels'` | Global variable name (required for IIFE format) |
| `base: './'` | Relative paths so assets load correctly on `file://` |
| `define: process.env.NODE_ENV` | Ensures React uses production build |

### Why Each HTML Transform Matters

| Transform | Purpose |
|-----------|---------|
| Strip `type="module"` | Module scripts trigger CORS on `file://` |
| Strip `crossorigin` | This attribute triggers CORS even on regular scripts! |
| Add `defer` | Vite puts script in `<head>`, defer ensures DOM is ready before execution |

### Output Structure

```
dist-portable/
├── index.html              # Transformed by plugin
├── assets/index-XXXXX.js   # IIFE bundle (React + app + CSS inlined)
└── favicon.svg             # Copied from public/
```

**Note:** CSS is automatically inlined in the JS bundle - no separate CSS file.

### Pros

- Simpler configuration (~25 lines)
- Uses `transformIndexHtml` (standard Vite hook)
- CSS auto-inlined (fewer output files)
- Single source of truth for HTML (no manual generation)

### Cons/Caveats

- Only tested with Rolldown-Vite (v7.2.5). Standard Vite may behave differently.
- `format: 'iife'` in app mode is not officially documented behavior
- If Rolldown-Vite changes how it handles format override, this could break

---

## Alternative Approach: Library Mode (More Reliable)

If the app mode approach stops working in future Vite versions, library mode is a documented, reliable fallback.

### Configuration

```typescript
// vite.config.portable.ts
import { dirname, resolve } from 'node:path';
import { readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { defineConfig, type Plugin } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';

const __dirname = dirname(fileURLToPath(import.meta.url));

const IIFE_JS_FILENAME = 'injuredpixels';
const CSS_FILENAME = 'injuredpixels';

/**
 * Generates index.html for the portable build by transforming
 * the source HTML to reference the IIFE bundle instead of ES modules.
 */
function portableHtmlPlugin(): Plugin {
  return {
    name: 'portable-html',
    closeBundle() {
      const html = readFileSync(resolve(__dirname, 'index.html'), 'utf-8');

      // Library mode skips HTML processing, so we manually add both CSS and JS
      const transformed = html
        .replace(
          '<script type="module" src="/src/main.tsx"></script>',
          `<link rel="stylesheet" href="./${CSS_FILENAME}.css">\n` +
            `    <script src="./${IIFE_JS_FILENAME}.iife.js"></script>`,
        )
        .replace(/href="\//g, 'href="./');

      writeFileSync(
        resolve(__dirname, 'dist-portable', 'index.html'),
        transformed,
      );
    },
  };
}

export default defineConfig({
  base: './',
  define: {
    'process.env.NODE_ENV': JSON.stringify('production'),
  },
  plugins: [
    react(),
    tailwindcss(),
    portableHtmlPlugin(),
  ],
  build: {
    outDir: 'dist-portable',
    lib: {
      entry: resolve(__dirname, 'src/main.tsx'),
      name: 'InjuredPixels',
      formats: ['iife'],
      fileName: IIFE_JS_FILENAME,
      cssFileName: CSS_FILENAME,
    },
  },
});
```

### Why Library Mode Is Different

Library mode (`build.lib`) is Vite's documented way to output non-ES-module formats like IIFE and UMD. However:

1. **Skips HTML processing** - Vite doesn't generate/transform `index.html` in library mode
2. **Requires manual HTML** - We use `closeBundle` hook to read source HTML and transform it
3. **CSS extracted separately** - Unlike app mode, CSS is not auto-inlined
4. **`process.env.NODE_ENV` not replaced** - Must be explicitly defined

### Output Structure

```
dist-portable/
├── index.html              # Generated by closeBundle plugin
├── injuredpixels.iife.js   # IIFE bundle
├── injuredpixels.css       # Extracted CSS
└── favicon.svg             # Copied from public/
```

### Pros

- Uses documented Vite API (`build.lib`)
- Guaranteed to produce IIFE output
- Works with standard Vite (not just Rolldown-Vite)

### Cons

- More complex configuration (~50 lines)
- Must use `closeBundle` instead of `transformIndexHtml`
- Manual HTML generation (replaces one element with two)
- Separate CSS file

---

## Testing

Always test the portable build in multiple browsers:

```bash
npm run build:portable
open dist-portable/index.html  # Opens in default browser via file://
```

Test in:
- Chrome/Brave
- Firefox
- Safari
- Edge

Check browser console for:
- CORS errors
- Script loading errors
- React runtime errors

---

## Troubleshooting

### "IIFE not supported for code-splitting builds"

Add `inlineDynamicImports: true` to `rollupOptions.output`.

### CORS error on script load

Check if:
1. `type="module"` is still on the script tag (should be stripped)
2. `crossorigin` attribute is present (should be stripped)

### "Target container is not a DOM element" (React error #299)

The script runs before DOM is ready. Add `defer` attribute to script tags.

### "process is not defined"

Add `define: { 'process.env.NODE_ENV': JSON.stringify('production') }` to config.

---

## References

- [Vite Library Mode](https://vitejs.dev/guide/build.html#library-mode)
- [Rolldown Output Formats](https://rolldown.rs/guide/output-formats)
