import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.license.insideIASI',
  appName: 'InsideIASI',
  webDir: 'dist/inside-iasi',
  bundledWebRuntime: false,
  server: {
    url: 'https://192.168.100.5:4200',
    cleartext: true
  }
};

export default config;
