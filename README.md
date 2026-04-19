# AniWatch Mobile App

Native iOS/iPadOS/Android app wrapper for **aniwatchtv.to** — built with Capacitor.

---

## Prerequisites

| Tool | Required For |
|------|-------------|
| Node.js 18+ | Both platforms |
| npm or yarn | Both platforms |
| Xcode 14+ | iOS / iPadOS |
| Apple Developer Account | iOS distribution |
| Android Studio | Android |
| Java JDK 17+ | Android |

---

## Setup (Both Platforms)

```bash
# 1. Install dependencies
npm install

# 2. Add your target platforms
npx cap add ios
npx cap add android

# 3. Sync the Capacitor config into native projects
npx cap sync
```

---

## iOS / iPadOS Build

### Step 1 — Apply Info.plist additions
Open `ios/App/App/Info.plist` in Xcode or a text editor.
Copy the keys from `ios-info-plist-additions.xml` into the `<dict>` section.

### Step 2 — Open in Xcode
```bash
npx cap open ios
```

### Step 3 — Configure signing
In Xcode → Targets → App → Signing & Capabilities:
- Select your Apple Developer Team
- Set Bundle Identifier: `com.aniwatch.app` (or your own)

### Step 4 — Run on device / simulator
Hit **Run (▶)** in Xcode. Select your iPhone or iPad.

> **Sideload without a paid account**: Use [AltStore](https://altstore.io) or
> [Sideloadly](https://sideloadly.io) to install the `.ipa` on your device
> with a free Apple ID (7-day refresh needed).

---

## Android Build

### Step 1 — Apply network security config
```bash
cp android-network-security-config.xml \
   android/app/src/main/res/xml/network_security_config.xml
```

Then open `android/app/src/main/AndroidManifest.xml` and add this attribute
inside the `<application>` tag:
```xml
android:networkSecurityConfig="@xml/network_security_config"
```

### Step 2 — Open in Android Studio
```bash
npx cap open android
```

### Step 3 — Run on device
Enable **USB Debugging** on your Android device:
Settings → About Phone → tap Build Number 7 times → Developer Options → USB Debugging ON

Then in Android Studio hit **Run (▶)** with your device connected.

### Step 4 — Build an APK (sideload without Play Store)
In Android Studio:
Build → Build Bundle(s) / APK(s) → Build APK(s)
The APK will be at: `android/app/build/outputs/apk/debug/app-debug.apk`
Transfer it to your device and install.

---

## How It Works

The `capacitor.config.ts` sets `server.url` to `https://aniwatchtv.to`, which
tells Capacitor's native WebView to load the live site directly — no local
bundling needed. The fallback `src/index.html` handles cases where the site
takes time to load, showing a splash screen first.

---

## Customization

| What | Where |
|------|-------|
| App name | `capacitor.config.ts` → `appName` |
| App icon | Replace `ios/App/App/Assets.xcassets/AppIcon.appiconset` and `android/app/src/main/res/mipmap-*` |
| Bundle ID | `capacitor.config.ts` → `appId` |
| Splash screen | Add `@capacitor/splash-screen` plugin |

---

## Updating

When the site updates, nothing needs to be done — the app always loads the live
URL. If you update the Capacitor config, run `npx cap sync` again.
