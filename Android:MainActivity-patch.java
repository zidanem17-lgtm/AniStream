package com.anistream.app;

// ─────────────────────────────────────────────────────────────
//  MainActivity-patch.java
//  Replace the contents of:
//  android/app/src/main/java/com/anistream/app/MainActivity.java
//  with this file after running `npx cap add android`.
// ─────────────────────────────────────────────────────────────

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // ── Register the ad + tracker blocking WebViewClient ───
        getBridge().setWebViewClient(new AniStreamWebViewClient(getBridge()));
        // ──────────────────────────────────────────────────────
    }
}
