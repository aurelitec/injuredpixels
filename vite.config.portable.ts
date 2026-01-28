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
 * This maintains a single HTML source of truth (index.html).
 */
function portableHtmlPlugin(): Plugin {
  return {
    name: 'portable-html',
    closeBundle() {
      const html = readFileSync(resolve(__dirname, 'index.html'), 'utf-8');

      // In app mode, Vite auto-injects CSS and JS into HTML. Library mode skips
      // HTML processing, so we manually add both: the CSS (normally injected by
      // Vite from `import './index.css'` in main.tsx) and the IIFE script.
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

/**
 * Portable ZIP build configuration.
 * - Builds as IIFE (not ES module) so browsers can load it via file:// protocol
 * - Uses relative paths (base: './') for file:// protocol compatibility
 * - Generates index.html from the source template with non-module script tags
 * - No PWA plugin (service workers don't work on file://)
 */
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
