// Takes the store screenshots of every screen, in every language, by driving
// a headless Chrome at the exact size of a phone. Run from the project root:
//
//   flutter build web --no-wasm-dry-run --pwa-strategy=none -t lib/screenshot_main.dart
//   node tool/store_screenshots.mjs
//
// Output: store/screenshots/<store>/<language>/NN-<screen>.png
import { spawn } from 'node:child_process';
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

const CHROME = process.env.CHROME ??
  '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const WEB_PORT = 8791;
const DEBUG_PORT = 9333;
const OUT = 'store/screenshots';

// App Store, 6.9" iPhone: 1290 x 2796. Google Play: at most 2:1, 1080 x 2160.
const TARGETS = [
  { store: 'ios', width: 430, height: 932 },
  { store: 'android', width: 360, height: 720 },
];
const LANGUAGES = ['it', 'en', 'es'];
const SHOTS = ['home', 'players', 'setup', 'turn', 'word', 'result', 'over'];

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

const profile = mkdtempSync(join(tmpdir(), 'shots-'));
const server = spawn('python3', [
  '-m', 'http.server', String(WEB_PORT), '--bind', '127.0.0.1',
  '--directory', 'build/web',
], { stdio: 'ignore' });
const chrome = spawn(CHROME, [
  '--headless=new', `--remote-debugging-port=${DEBUG_PORT}`,
  `--user-data-dir=${profile}`, '--hide-scrollbars', 'about:blank',
], { stdio: 'ignore' });

try {
  // Wait for the browser, then talk to its first page.
  let page;
  for (let attempt = 0; attempt < 50 && !page; attempt++) {
    await sleep(200);
    try {
      const pages = await (await fetch(`http://127.0.0.1:${DEBUG_PORT}/json`)).json();
      page = pages.find((entry) => entry.type === 'page');
    } catch (_) { /* not up yet */ }
  }
  if (!page) throw new Error('Chrome did not start');

  const socket = new WebSocket(page.webSocketDebuggerUrl);
  await new Promise((resolve) => socket.addEventListener('open', resolve));

  let nextId = 0;
  const pending = new Map();
  socket.addEventListener('message', (event) => {
    const message = JSON.parse(event.data);
    if (pending.has(message.id)) {
      pending.get(message.id)(message.result);
      pending.delete(message.id);
    }
  });
  const send = (method, params = {}) => new Promise((resolve) => {
    const id = ++nextId;
    pending.set(id, resolve);
    socket.send(JSON.stringify({ id, method, params }));
  });

  for (const { store, width, height } of TARGETS) {
    await send('Emulation.setDeviceMetricsOverride', {
      width, height, deviceScaleFactor: 3, mobile: true,
    });

    for (const lang of LANGUAGES) {
      mkdirSync(join(OUT, store, lang), { recursive: true });

      for (const [index, shot] of SHOTS.entries()) {
        await send('Page.navigate', {
          url: `http://127.0.0.1:${WEB_PORT}/?shot=${shot}&lang=${lang}`,
        });
        // The entry point freezes the animations a few seconds after it has
        // opened the screen: by now the picture no longer changes.
        await sleep(9000);

        const { data } = await send('Page.captureScreenshot', { format: 'png' });
        const file = join(OUT, store, lang, `0${index + 1}-${shot}.png`);
        writeFileSync(file, Buffer.from(data, 'base64'));
        console.log(file);
      }
    }
  }

  socket.close();
} finally {
  chrome.kill();
  server.kill();
  await sleep(500);
  rmSync(profile, { recursive: true, force: true });
}
