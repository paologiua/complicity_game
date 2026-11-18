# Logo

`build_logo.py` draws the wordmark from the app's own pieces:

- the letters in Poppins (`fonts/Poppins`), with their outer corners rounded;
- the spiral of the app icon (`design/icon/app-icon.svg`), orange for the "o"
  and green, upside down, for the "G";
- the bulb in `bulb.svg`: `emoji_objects` from Material Symbols, Rounded
  style, weight 700 (Apache License 2.0);
- a dark outline grown around all of them, with no gaps in the middle.

It writes `assets/images/splash-icon.svg`, updates the aspect ratio in
`lib/widgets/game_logo.dart` and redraws the link preview `web/og-image.png`.
To change the look, edit the constants at the top of the script and run it
again.

## Running

It needs Python 3 with `fonttools` and `skia-pathops`, and `rsvg-convert` and
ImageMagick for the link preview (`brew install librsvg imagemagick`):

```sh
python3 -m venv /tmp/logo-venv
/tmp/logo-venv/bin/pip install fonttools skia-pathops
/tmp/logo-venv/bin/python design/logo/build_logo.py
```

Then rebuild the app (`flutter build web` for the web version).
