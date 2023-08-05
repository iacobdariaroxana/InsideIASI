import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.license.insideIASI',
  appName: 'InsideIASI',
  webDir: 'dist/inside-iasi',
  bundledWebRuntime: false,
  server: {
    url: 'https://inside-iasi.netlify.app',
    cleartext: true
  }
};

export default config;
