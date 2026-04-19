import UIKit
import WebKit
import Capacitor

// ─────────────────────────────────────────────────────────────
//  AniStreamContentBlocker.swift
//  Drop this file into: ios/App/App/AniStreamContentBlocker.swift
//  Then call AniStreamContentBlocker.apply(to: webView) inside
//  your AppDelegate or CAPBridgeViewController after the WebView
//  is initialised.
// ─────────────────────────────────────────────────────────────

class AniStreamContentBlocker {

    // ── Blocklist rules (WKContentRuleList JSON format) ────────
    // Each rule is { "trigger": {...}, "action": {...} }
    // trigger.url-filter uses regex matched against the request URL.
    static let rules: [[String: Any]] = [

        // ── Major ad networks ──────────────────────────────────
        blockDomain("doubleclick.net"),
        blockDomain("googlesyndication.com"),
        blockDomain("googleadservices.com"),
        blockDomain("google-analytics.com"),
        blockDomain("adservice.google.com"),
        blockDomain("pagead2.googlesyndication.com"),
        blockDomain("ads.youtube.com"),
        blockDomain("adnxs.com"),          // AppNexus
        blockDomain("adsrvr.org"),          // The Trade Desk
        blockDomain("advertising.com"),
        blockDomain("outbrain.com"),
        blockDomain("taboola.com"),
        blockDomain("criteo.com"),
        blockDomain("rubiconproject.com"),
        blockDomain("openx.net"),
        blockDomain("pubmatic.com"),
        blockDomain("smartadserver.com"),
        blockDomain("spotxchange.com"),
        blockDomain("lijit.com"),
        blockDomain("sovrn.com"),
        blockDomain("media.net"),
        blockDomain("revcontent.com"),
        blockDomain("mgid.com"),
        blockDomain("propellerads.com"),
        blockDomain("popcash.net"),
        blockDomain("popads.net"),
        blockDomain("exoclick.com"),        // common on anime sites
        blockDomain("juicyads.com"),
        blockDomain("trafficjunky.net"),
        blockDomain("trafficstars.com"),

        // ── Trackers ───────────────────────────────────────────
        blockDomain("hotjar.com"),
        blockDomain("mouseflow.com"),
        blockDomain("fullstory.com"),
        blockDomain("logrocket.com"),
        blockDomain("segment.com"),
        blockDomain("mixpanel.com"),
        blockDomain("amplitude.com"),
        blockDomain("heap.io"),
        blockDomain("clearbit.com"),
        blockDomain("intercom.io"),
        blockDomain("intercom.com"),
        blockDomain("drift.com"),
        blockDomain("hubspot.com"),
        blockDomain("marketo.com"),
        blockDomain("pardot.com"),
        blockDomain("facebook.net"),        // Meta pixel
        blockDomain("connect.facebook.net"),
        blockDomain("pixel.facebook.com"),
        blockDomain("analytics.twitter.com"),
        blockDomain("static.ads-twitter.com"),
        blockDomain("snap.licdn.com"),
        blockDomain("bat.bing.com"),
        blockDomain("mc.yandex.ru"),
        blockDomain("mc.yandex.com"),
        blockDomain("counter.ok.ru"),

        // ── Fingerprinting / device tracking ──────────────────
        blockDomain("fingerprintjs.com"),
        blockDomain("iovation.com"),
        blockDomain("threatmetrix.com"),
        blockDomain("device.fingerprint.com"),

        // ── Crypto miners ─────────────────────────────────────
        blockDomain("coinhive.com"),
        blockDomain("coin-hive.com"),
        blockDomain("cryptoloot.pro"),
        blockDomain("minero.cc"),
        blockDomain("webminepool.com"),
        blockDomain("jsecoin.com"),
        blockDomain("monerominer.rocks"),

        // ── Popup / redirect scripts ──────────────────────────
        blockPattern(".*\\/ads\\/.*"),
        blockPattern(".*\\/adserver\\/.*"),
        blockPattern(".*\\/adserve\\/.*"),
        blockPattern(".*\\/tracking\\/.*"),
        blockPattern(".*\\/tracker\\/.*"),
        blockPattern(".*\\/pixel\\/.*"),
        blockPattern(".*\\/telemetry\\/.*"),
        blockPattern(".*\\/analytics\\/collect.*"),

        // ── Hide ad-injected DOM elements ─────────────────────
        cssHide(selector: ".ad, .ads, .ad-container, .advertisement, .banner-ad, #ad, #ads, #advertisement, .popup-ad, .overlay-ad, [id^='google_ads'], [id^='div-gpt-ad'], .dfp-ad, .adsense, ins.adsbygoogle"),
    ]

    // ── Helpers ────────────────────────────────────────────────

    private static func blockDomain(_ domain: String) -> [String: Any] {
        return [
            "trigger": [
                "url-filter": ".*\(NSRegularExpression.escapedPattern(for: domain)).*",
                "url-filter-is-case-sensitive": false
            ],
            "action": ["type": "block"]
        ]
    }

    private static func blockPattern(_ pattern: String) -> [String: Any] {
        return [
            "trigger": [
                "url-filter": pattern,
                "url-filter-is-case-sensitive": false
            ],
            "action": ["type": "block"]
        ]
    }

    private static func cssHide(selector: String) -> [String: Any] {
        return [
            "trigger": ["url-filter": ".*"],
            "action": [
                "type": "css-display-none",
                "selector": selector
            ]
        ]
    }

    // ── Apply to WebView ───────────────────────────────────────

    static func apply(to webView: WKWebView) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: rules),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("[AniStream] ⚠️ Failed to serialise blocker rules")
            return
        }

        WKContentRuleListStore.default().compileContentRuleList(
            forIdentifier: "AniStreamBlocker",
            encodedContentRuleList: jsonString
        ) { ruleList, error in
            if let error = error {
                print("[AniStream] ⚠️ Blocker compile error: \(error.localizedDescription)")
                return
            }
            guard let ruleList = ruleList else { return }
            DispatchQueue.main.async {
                webView.configuration.userContentController.add(ruleList)
                print("[AniStream] ✅ Content blocker active — \(rules.count) rules loaded")
            }
        }
    }
}
