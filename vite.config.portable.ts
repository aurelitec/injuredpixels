import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';

/**
 * Portable ZIP build configuration.
 * - Uses relative paths (base: './') for file:// protocol compatibility
 * - No PWA plugin (service workers don't work on file://)
 */
export default defineConfig({
  base: './',
  plugins: [
    react(),
    tailwindcss(),
  ],
  build: {
    outDir: 'dist-portable',
  },
});
