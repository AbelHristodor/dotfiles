// ==UserScript==
// @name         Two-Pane Split View (with Sticky Toggle Button)
// @namespace    http://tampermonkey.net/
// @version      1.6
// @description  Adds a sticky button on top of all pages to split the tab into two iframes side-by-side with draggable divider and controls.
// @author       AbelHristodor
// @match        *://*/*
// @run-at       document-end
// @grant        GM_getValue
// @grant        GM_setValue
// ==/UserScript==

(function () {
  'use strict';

  const DEFAULT_LEFT = location.href;
  const DEFAULT_RIGHT = 'https://www.example.com';
  const STORAGE_KEY = 'two_pane_urls_v1';
  const MIN_PANE_WIDTH_PX = 150;

  function saveUrls(left, right) {
    try { GM_setValue(STORAGE_KEY, JSON.stringify({ left, right })); } catch (e) {}
  }

  function loadUrls() {
    try {
      const raw = GM_getValue(STORAGE_KEY);
      if (!raw) return { left: DEFAULT_LEFT, right: DEFAULT_RIGHT };
      const p = JSON.parse(raw);
      return { left: p.left || DEFAULT_LEFT, right: p.right || DEFAULT_RIGHT };
    } catch {
      return { left: DEFAULT_LEFT, right: DEFAULT_RIGHT };
    }
  }

  // ---------- Sticky Toggle Button ----------
  const btn = document.createElement('button');
  btn.id = 'tm-splitview-btn';
  btn.textContent = '🔀 Split View';
  Object.assign(btn.style, {
    position: 'fixed',
    top: '8px',
    right: '8px',
    zIndex: 2147483647,
    background: '#007aff',
    color: '#fff',
    border: 'none',
    borderRadius: '6px',
    padding: '6px 12px',
    fontSize: '13px',
    cursor: 'pointer',
    fontFamily: 'system-ui, sans-serif',
    boxShadow: '0 2px 8px rgba(0,0,0,0.25)',
    opacity: '0.9',
  });
  btn.addEventListener('mouseenter', () => btn.style.opacity = '1');
  btn.addEventListener('mouseleave', () => btn.style.opacity = '0.9');
  document.body.appendChild(btn);

  // ---------- Toggle Split View Overlay ----------
  btn.addEventListener('click', () => {
    const existing = document.getElementById('tm-two-pane-overlay');
    if (existing) {
      existing.remove();
      return;
    }
    openSplitView();
  });

  function openSplitView() {
    const urls = loadUrls();

    const overlay = document.createElement('div');
    overlay.id = 'tm-two-pane-overlay';
    Object.assign(overlay.style, {
      position: 'fixed',
      inset: '0',
      background: '#fff',
      zIndex: 2147483646,
      display: 'flex',
      height: '100vh',
      width: '100vw',
      overflow: 'hidden',
      fontFamily: 'system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial',
    });

    const leftPane = document.createElement('div');
    Object.assign(leftPane.style, {
      height: '100%',
      width: '50%',
      minWidth: MIN_PANE_WIDTH_PX + 'px',
      borderRight: '1px solid rgba(0,0,0,0.08)',
    });

    const rightPane = document.createElement('div');
    Object.assign(rightPane.style, {
      height: '100%',
      width: '50%',
      minWidth: MIN_PANE_WIDTH_PX + 'px',
    });

    function makeIframe(src) {
      const f = document.createElement('iframe');
      f.src = src;
      Object.assign(f.style, {
        width: '100%',
        height: '100%',
        border: 'none',
        background: '#fff',
      });
      f.setAttribute('sandbox', 'allow-forms allow-scripts allow-same-origin allow-popups allow-modals');
      return f;
    }

    const leftFrame = makeIframe(urls.left);
    const rightFrame = makeIframe(urls.right);

    // Control bar
    const controlBar = document.createElement('div');
    Object.assign(controlBar.style, {
      position: 'absolute',
      top: '8px',
      left: '50%',
      transform: 'translateX(-50%)',
      zIndex: 100000,
      display: 'flex',
      gap: '8px',
      alignItems: 'center',
      background: 'rgba(255,255,255,0.95)',
      padding: '6px 8px',
      borderRadius: '8px',
      boxShadow: '0 6px 20px rgba(0,0,0,0.12)',
      border: '1px solid rgba(0,0,0,0.06)',
    });

    const leftInput = document.createElement('input');
    leftInput.type = 'url';
    leftInput.value = urls.left;
    Object.assign(leftInput.style, { width: '28ch', padding: '6px', borderRadius: '6px', border: '1px solid #ccc' });

    const rightInput = document.createElement('input');
    rightInput.type = 'url';
    rightInput.value = urls.right;
    Object.assign(rightInput.style, { width: '28ch', padding: '6px', borderRadius: '6px', border: '1px solid #ccc' });

    const loadBtn = document.createElement('button');
    loadBtn.textContent = 'Load';
    const closeBtn = document.createElement('button');
    closeBtn.textContent = 'Close';

    [loadBtn, closeBtn].forEach(btn => Object.assign(btn.style, {
      padding: '6px 10px',
      borderRadius: '6px',
      cursor: 'pointer',
      border: '1px solid #ddd',
    }));

    controlBar.append(leftInput, rightInput, loadBtn, closeBtn);

    const divider = document.createElement('div');
    Object.assign(divider.style, {
      width: '8px',
      cursor: 'col-resize',
      background: 'transparent',
      position: 'relative',
      zIndex: 99999,
    });
    const divHandle = document.createElement('div');
    Object.assign(divHandle.style, { width: '2px', height: '40%', background: 'rgba(0,0,0,0.12)' });
    divider.appendChild(divHandle);

    leftPane.appendChild(leftFrame);
    rightPane.appendChild(rightFrame);
    overlay.append(leftPane, divider, rightPane, controlBar);
    document.documentElement.appendChild(overlay);

    // Divider drag
    let dragging = false;
    divider.addEventListener('mousedown', e => { dragging = true; e.preventDefault(); });
    window.addEventListener('mousemove', e => {
      if (!dragging) return;
      const total = window.innerWidth;
      const leftW = Math.max(MIN_PANE_WIDTH_PX, Math.min(e.clientX, total - MIN_PANE_WIDTH_PX - 8));
      const pct = (leftW / total) * 100;
      leftPane.style.width = pct + '%';
      rightPane.style.width = (100 - pct) + '%';
    });
    window.addEventListener('mouseup', () => dragging = false);

    // Button actions
    loadBtn.onclick = () => {
      const l = leftInput.value.trim() || DEFAULT_LEFT;
      const r = rightInput.value.trim() || DEFAULT_RIGHT;
      leftFrame.src = l;
      rightFrame.src = r;
      saveUrls(l, r);
    };
    closeBtn.onclick = () => overlay.remove();
  }

})();
