import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.license.insideIASI',
  appName: 'InsideIASI',
  webDir: 'dist/inside-iasi',
  bundledWebRuntime: false,
  server: {
    url: 'http://192.168.224.121:4200',
    cleartext: true
  }
};

export default config;
