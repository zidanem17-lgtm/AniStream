/**
 * AniStream Ad Cosmetic Filter
 * ─────────────────────────────────────────────────────────────
 * This script is injected into the WebView on every page load.
 *
 * iOS:  Add via WKUserScript in AniStreamContentBlocker.swift
 * Android: Call webView.evaluateJavascript() in onPageFinished()
 *
 * It hides ad elements that slip through network-level blocking
 * by watching the DOM for injected ad nodes.
 */

(function () {
  'use strict';

  // ── CSS selectors for ad/popup elements to hide ────────────
  const AD_SELECTORS = [
    // Generic ad classes
    '.ad', '.ads', '.ad-unit', '.ad-container', '.ad-wrapper',
    '.advertisement', '.banner-ad', '.sponsored', '.promo',
    '.adsbygoogle', 'ins.adsbygoogle',

    // IDs
    '#ad', '#ads', '#advertisement', '#banner-ad',
    '[id^="google_ads_"]', '[id^="div-gpt-ad"]',
    '[id^="ad-slot"]', '[id^="ad_slot"]',

    // Popups and overlays
    '.popup', '.popup-overlay', '.modal-overlay',
    '.interstitial', '.lightbox-ad',
    '[class*="popup"]', '[class*="overlay"][class*="ad"]',

    // Video ads
    '.video-ads', '.preroll', '.ad-overlay',
    '[class*="vast"]', '[class*="vpaid"]',

    // Anime-site specific common patterns
    '.dplayer-ad', '.jw-ad', '.jwplayer-ad',
    '[id*="preroll"]', '[class*="preroll"]',
    '.aniads', '[id^="aniads"]',

    // iframes from ad servers
    'iframe[src*="doubleclick"]',
    'iframe[src*="googlesyndication"]',
    'iframe[src*="exoclick"]',
    'iframe[src*="trafficjunky"]',
    'iframe[src*="popads"]',
    'iframe[src*="popcash"]',
  ].join(', ');

  // ── Inject a style tag to hide all matched elements ────────
  function injectStyles () {
    const style = document.createElement('style');
    style.id = '__anistream_blocker__';
    style.textContent = `${AD_SELECTORS} { display: none !important; visibility: hidden !important; pointer-events: none !important; }`;
    document.head.appendChild(style);
  }

  // ── Observe DOM mutations for dynamically injected ads ─────
  function observeDOM () {
    const observer = new MutationObserver((mutations) => {
      for (const mutation of mutations) {
        for (const node of mutation.addedNodes) {
          if (node.nodeType !== 1) continue; // elements only

          // Remove if node itself matches
          try {
            if (node.matches && node.matches(AD_SELECTORS)) {
              node.remove();
              continue;
            }
          } catch (_) {}

          // Remove any matching descendants
          try {
            node.querySelectorAll(AD_SELECTORS).forEach(el => el.remove());
          } catch (_) {}
        }
      }
    });

    observer.observe(document.documentElement, {
      childList: true,
      subtree: true,
    });
  }

  // ── Block window.open popups (common on anime sites) ───────
  window.open = function () {
    console.log('[AniStream] Blocked window.open popup');
    return null;
  };

  // ── Block alert/confirm spam ────────────────────────────────
  window.alert   = function () {};
  window.confirm = function () { return false; };
  window.prompt  = function () { return null; };

  // ── Block navigation away from the site ────────────────────
  window.addEventListener('beforeunload', function (e) {
    e.preventDefault();
    e.returnValue = '';
  });

  // ── Init ────────────────────────────────────────────────────
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
      injectStyles();
      observeDOM();
    });
  } else {
    injectStyles();
    observeDOM();
  }

  console.log('[AniStream] ✅ Cosmetic ad filter active');
})();
