"""Render scripts/og/card.html to og-pt.png and og-en.png (1200 x 630) at the repo root.

Needs Playwright with Chromium. It is not part of the deploy: run `make og` only
when the card changes and commit the two PNGs.
"""
from pathlib import Path

from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parents[2]
CARD = (ROOT / "scripts" / "og" / "card.html").as_uri()

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page(viewport={"width": 1200, "height": 630}, device_scale_factor=1)
    for lang in ("pt", "en"):
        page.goto(f"{CARD}?lang={lang}", wait_until="networkidle")
        page.wait_for_selector("body[data-ready]")
        page.evaluate("document.fonts.ready")
        out = ROOT / f"og-{lang}.png"
        page.screenshot(path=str(out))
        print(f"wrote {out.relative_to(ROOT)}")
    browser.close()
