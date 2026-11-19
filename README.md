# Complicity Game

A party game of secret words for two teams sharing one phone. One player sees
a hidden word and gives clues; their team has to guess it before the other
team steals it. The first team to reach the chosen number of words wins.

Four modes share the same rules with a different tone: Classic, Drinking,
Dares and Spicy. The game is available in English, Italian and Spanish.

## Running

```sh
flutter pub get
flutter run
```

## Project layout

- `lib/screens` – one file per screen of the game
- `lib/widgets` – shared clay-style components and the animated background
- `lib/services` – game state and the saved list of players
- `lib/l10n` – translations (run `flutter gen-l10n` after editing the `.arb` files)
- `assets/data` – word lists and dares, one file per language
- `design/icon` – sources of the app icon (run `dart run flutter_launcher_icons` after changing them)
- `design/logo` – the script that draws the logo and the link preview
- `word_sources` – the larger word lists the game lists were picked from; not shipped with the app

## Web version

```sh
flutter build web --release --wasm
```

The site is served from `build/web` on Cloudflare Pages. Build it with
`--wasm`: Safari then runs Flutter's skwasm renderer, which keeps the
animations smooth on iPhone, while browsers without WebAssembly GC fall back
to the JavaScript build. `web/flutter_bootstrap.js` turns skwasm on for
Safari, and `web/_headers` makes the page cross-origin isolated so skwasm can
draw on a thread of its own. Because of that isolation the page cannot load
files from other sites.

To publish it, deploy `build/web` to the `complicity-game` Pages project
(check first that `build/web/_headers` is there):

```sh
npx --yes wrangler pages deploy build/web --project-name complicity-game --branch main
```
