import { defineConfig, type Plugin } from 'vite';
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
    ViteMinifyPlugin(),
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
