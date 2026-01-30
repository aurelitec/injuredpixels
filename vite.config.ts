import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';
import { VitePWA } from 'vite-plugin-pwa';
import { ViteMinifyPlugin } from 'vite-plugin-minify';

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    react(),
    tailwindcss(),
    VitePWA({
      registerType: 'autoUpdate',
      includeAssets: ['favicon.ico', 'favicon-96x96.png', 'Icon-192.png'],
      manifest: {
        name: 'InjuredPixels',
        short_name: 'InjuredPixels',
        description: 'Detect dead, stuck, or hot pixels on your display',
        theme_color: '#000000',
        background_color: '#000000',
        display: 'fullscreen',
        orientation: 'any',
        start_url: '/',
        icons: [
          {
            src: 'Icon-192.png',
            sizes: '192x192',
            type: 'image/png',
          },
          {
            src: 'Icon-512.png',
            sizes: '512x512',
            type: 'image/png',
          },
          {
            src: 'Icon-maskable-192.png',
            sizes: '192x192',
            type: 'image/png',
            purpose: 'maskable',
          },
          {
            src: 'Icon-maskable-512.png',
            sizes: '512x512',
            type: 'image/png',
            purpose: 'maskable',
          },
        ],
      },
      workbox: {
        globPatterns: ['**/*.{js,css,html,svg,png,ico}'],
      },
    }),
    ViteMinifyPlugin(),
  ],
});
