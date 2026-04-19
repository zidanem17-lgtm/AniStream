import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.aniwatch.app',
  appName: 'AniWatch',
  webDir: 'src',
  server: {
    // Points the native WebView directly at the live site
    url: 'https://aniwatchtv.to',
    cleartext: false,
    allowNavigation: [
      'aniwatchtv.to',
      '*.aniwatchtv.to',
    ],
  },
  ios: {
    contentInset: 'automatic',
    allowsLinkPreview: false,
    scrollEnabled: true,
  },
  android: {
    allowMixedContent: false,
    captureInput: true,
    webContentsDebuggingEnabled: false,
  },
};

export default config;
