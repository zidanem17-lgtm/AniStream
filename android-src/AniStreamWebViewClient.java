package com.anistream.app;

// ─────────────────────────────────────────────────────────────
//  AniStreamWebViewClient.java
//  Place this file at:
//  android/app/src/main/java/com/anistream/app/AniStreamWebViewClient.java
//
//  Then open:
//  android/app/src/main/java/com/anistream/app/MainActivity.java
//  and register the client (see MainActivity-patch.java).
// ─────────────────────────────────────────────────────────────

import android.graphics.Bitmap;
import android.util.Log;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import com.getcapacitor.BridgeWebViewClient;
import com.getcapacitor.Bridge;
import java.io.ByteArrayInputStream;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class AniStreamWebViewClient extends BridgeWebViewClient {

    private static final String TAG = "AniStreamBlocker";

    // ── Blocked domains ────────────────────────────────────────
    private static final Set<String> BLOCKED_DOMAINS = new HashSet<>(Arrays.asList(

        // Ad networks
        "doubleclick.net",
        "googlesyndication.com",
        "googleadservices.com",
        "google-analytics.com",
        "adservice.google.com",
        "pagead2.googlesyndication.com",
        "adnxs.com",
        "adsrvr.org",
        "advertising.com",
        "outbrain.com",
        "taboola.com",
        "criteo.com",
        "rubiconproject.com",
        "openx.net",
        "pubmatic.com",
        "smartadserver.com",
        "spotxchange.com",
        "sovrn.com",
        "media.net",
        "revcontent.com",
        "mgid.com",
        "propellerads.com",
        "popcash.net",
        "popads.net",
        "exoclick.com",
        "juicyads.com",
        "trafficjunky.net",
        "trafficstars.com",

        // Trackers
        "hotjar.com",
        "mouseflow.com",
        "fullstory.com",
        "logrocket.com",
        "segment.com",
        "mixpanel.com",
        "amplitude.com",
        "heap.io",
        "clearbit.com",
        "intercom.io",
        "drift.com",
        "hubspot.com",
        "marketo.com",
        "facebook.net",
        "connect.facebook.net",
        "pixel.facebook.com",
        "analytics.twitter.com",
        "static.ads-twitter.com",
        "bat.bing.com",
        "mc.yandex.ru",
        "mc.yandex.com",

        // Fingerprinting
        "fingerprintjs.com",
        "iovation.com",
        "threatmetrix.com",

        // Crypto miners
        "coinhive.com",
        "coin-hive.com",
        "cryptoloot.pro",
        "minero.cc",
        "webminepool.com",
        "jsecoin.com"
    ));

    // ── Blocked URL path patterns ──────────────────────────────
    private static final String[] BLOCKED_PATTERNS = {
        "/ads/",
        "/adserver/",
        "/adserve/",
        "/tracking/",
        "/tracker/",
        "/telemetry/",
        "/analytics/collect",
        "/pixel/",
        "doubleclick",
        "googlesyndication",
        "adsbygoogle"
    };

    // ── Empty response returned for blocked requests ───────────
    private static final WebResourceResponse EMPTY_RESPONSE =
        new WebResourceResponse("text/plain", "utf-8",
            new ByteArrayInputStream("".getBytes()));

    public AniStreamWebViewClient(Bridge bridge) {
        super(bridge);
    }

    @Override
    public WebResourceResponse shouldInterceptRequest(
            WebView view, WebResourceRequest request) {

        String url = request.getUrl().toString().toLowerCase();
        String host = request.getUrl().getHost();

        if (host != null) {
            // Strip leading www.
            String cleanHost = host.startsWith("www.") ? host.substring(4) : host;

            // Check exact domain and subdomains
            for (String blocked : BLOCKED_DOMAINS) {
                if (cleanHost.equals(blocked) || cleanHost.endsWith("." + blocked)) {
                    Log.d(TAG, "Blocked domain: " + host);
                    return EMPTY_RESPONSE;
                }
            }
        }

        // Check URL path patterns
        for (String pattern : BLOCKED_PATTERNS) {
            if (url.contains(pattern)) {
                Log.d(TAG, "Blocked pattern '" + pattern + "' in: " + url);
                return EMPTY_RESPONSE;
            }
        }

        // Allow everything else through
        return super.shouldInterceptRequest(view, request);
    }
}
