/** @type {import('@capacitor/cli').CapacitorConfig} */
const config = {
  appId: 'com.anistream.app',
  appName: 'AniStream',
  webDir: 'src',
  server: {
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

module.exports = config;
