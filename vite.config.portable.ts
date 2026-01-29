import { defineConfig, type Plugin } from 'vite';
import { copyFileSync, readdirSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';
import { ViteMinifyPlugin } from 'vite-plugin-minify';

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

/**
 * Copies static files (README.txt, LICENSE.txt) from the portable/
 * directory into the build output after bundling completes.
 */
function portableStaticFilesPlugin(): Plugin {
  return {
    name: 'portable-static-files',
    closeBundle() {
      const srcDir = resolve(__dirname, 'portable');
      const outDir = resolve(__dirname, 'dist-portable');
      for (const file of readdirSync(srcDir)) {
        copyFileSync(join(srcDir, file), join(outDir, file));
      }
    },
  };
}

/**
 * Portable ZIP build configuration.
 * - Builds as IIFE format (works with Rolldown-Vite when inlineDynamicImports is enabled)
 * - Uses relative paths (base: './') for file:// protocol compatibility
 * - CSS is auto-inlined in the JS bundle
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
    portableStaticFilesPlugin(),
    ViteMinifyPlugin(),
  ],
  build: {
    outDir: 'dist-portable',
    assetsDir: '',
    rollupOptions: {
      output: {
        format: 'iife',
        name: 'InjuredPixels',
        inlineDynamicImports: true,
        entryFileNames: 'injuredpixels.js',
        assetFileNames: '[name][extname]',
      },
    },
  },
});
