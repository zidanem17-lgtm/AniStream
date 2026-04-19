// ─────────────────────────────────────────────────────────────
//  HOW TO WIRE UP THE CONTENT BLOCKER ON iOS
//  File: ios/App/App/AppDelegate.swift  (already exists after `npx cap add ios`)
// ─────────────────────────────────────────────────────────────
//
//  Find the existing AppDelegate.swift and replace / patch it so
//  it looks like the example below.  The only thing you are adding
//  is the AniStreamContentBlocker.apply(to:) call.
//
// ─────────────────────────────────────────────────────────────

import UIKit
import Capacitor

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // ── Activate ad + tracker blocker ──────────────────────
        // Bridge.webView is the WKWebView Capacitor creates.
        // We wait one run-loop tick to ensure it's initialised.
        DispatchQueue.main.async {
            if let webView = self.window?.rootViewController?.view.subviews
                .compactMap({ $0 as? WKWebView }).first {
                AniStreamContentBlocker.apply(to: webView)
            }
        }
        // ──────────────────────────────────────────────────────

        return true
    }

    // Keep any other existing AppDelegate methods below unchanged.
}
