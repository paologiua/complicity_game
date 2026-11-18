"""Builds the Complicity Game wordmark.

Writes assets/images/splash-icon.svg, the link preview web/og-image.png and
the aspect ratio in lib/widgets/game_logo.dart. See README.md beside this file.
"""

import math
import re
import shutil
import subprocess
import tempfile
from pathlib import Path

import pathops
from fontTools.misc.transform import Transform
from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.pens.transformPen import TransformPen
from fontTools.svgLib.path import parse_path
from fontTools.ttLib import TTFont

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent

# --- Look -------------------------------------------------------------------
WEIGHT = "ExtraBold"  # Poppins weight of the letters
CORNER_RADIUS = 3.0  # rounding of the outer corners of each letter
BORDER = 23.0  # width of the dark outline around everything
SOFTEN = 12.0  # how much the outline fills the dips between letters
SPIRAL_THICKEN = 1.6  # the spirals are grown a little to match the letters

INK = "#2b2233"
WHITE = "#ffffff"
ORANGE = "#fda65a"
GREEN = "#8ee5a8"
YELLOW = "#ffdb6e"
BACKGROUND = "#FFF7ED"  # behind the logo in the link preview

# --- Layout (units of a 100-unit font size) --------------------------------
SIZE = 100.0
TRACKING = -12  # in font units
GAP = 2.5  # between a spiral and the next letter
BASELINE_1 = 100.0
BASELINE_2 = BASELINE_1 + 96.0
SPIRAL_HEIGHT = 1.12  # times the cap height
BULB_HEIGHT = 1.6  # times the cap height
BULB_ANGLE = 20  # degrees, leaning right
BULB_DX = 24  # after the end of "ame"
BULB_DY = 20  # below the second baseline
PAD = 2

OG_SIZE = (1200, 630)
OG_LOGO_WIDTH = 720

# --- Sources ----------------------------------------------------------------
font = TTFont(ROOT / f"fonts/Poppins/Poppins-{WEIGHT}.ttf")
glyphs = font.getGlyphSet()
cmap = font.getBestCmap()
hmtx = font["hmtx"]
k = SIZE / font["head"].unitsPerEm
cap = font["OS/2"].sCapHeight * k

# The spiral of the app icon; it is an icomoon glyph, so y points up.
icon = (ROOT / "design/icon/app-icon.svg").read_text()
SPIRAL = re.search(r'<path d="(M513\.81[^"]+)"', icon).group(1)
SPIRAL_FLIP = Transform(1, 0, 0, -1, 0, 0)
# emoji_objects, Material Symbols Rounded, weight 700.
BULB = re.search(r'd="([^"]+)"', (HERE / "bulb.svg").read_text()).group(1)


# --- Geometry ---------------------------------------------------------------
def new():
    return pathops.Path(fillType=pathops.FillType.WINDING)


def _stroke(p, r):
    s = new()
    s.addPath(p)
    s.stroke(2 * r, pathops.LineCap.ROUND_CAP, pathops.LineJoin.ROUND_JOIN, 4)
    s.convertConicsToQuads()
    return s


def dilate(p, r):
    return pathops.op(p, _stroke(p, r), pathops.PathOp.UNION)


def erode(p, r):
    return pathops.op(p, _stroke(p, r), pathops.PathOp.DIFFERENCE)


def outer_only(p):
    """Drops the holes, keeping the contours wound like the largest one."""
    p = pathops.simplify(p, fix_winding=True)
    contours = list(p.contours)
    outer = max(contours, key=lambda c: abs(c.area)).clockwise
    res = new()
    for c in contours:
        if c.clockwise == outer:
            res = pathops.op(res, c, pathops.PathOp.UNION)
    return res


def text(s, x, baseline):
    """Draws s from x on the baseline; returns the path and the end x."""
    p = new()
    for ch in s:
        g = cmap[ord(ch)]
        gp = new()
        glyphs[g].draw(TransformPen(gp.getPen(), Transform(k, 0, 0, -k, x, baseline)))
        if CORNER_RADIUS:
            # Rounded one letter at a time, so nothing between letters or
            # inside an "e" can fill in.
            gp = pathops.simplify(gp, fix_winding=True)
            gp = dilate(erode(gp, CORNER_RADIUS), CORNER_RADIUS)
        p = pathops.op(p, gp, pathops.PathOp.UNION)
        x += (hmtx[g][0] + TRACKING) * k
    return p, x


def svg_shape(d, t):
    p = new()
    parse_path(d, TransformPen(p.getPen(), t))
    return p


def fit(d, pre, height, angle=0):
    """The svg path d scaled to `height`, turned by `angle` degrees."""
    x0, y0, x1, y1 = svg_shape(d, pre).bounds
    t = Transform().rotate(angle * math.pi / 180).scale(height / (y1 - y0))
    t = t.translate(-(x0 + x1) / 2, -(y0 + y1) / 2)
    return svg_shape(d, t.transform(pre))


def place(p, left=None, top=None, bottom=None):
    x0, y0, _, y1 = p.bounds
    dx = 0 if left is None else left - x0
    dy = 0 if top is None else top - y0
    if bottom is not None:
        dy = bottom - y1
    q = new()
    p.draw(TransformPen(q.getPen(), Transform().translate(dx, dy)))
    return q


def svg_d(p):
    pen = SVGPathPen(None, ntos=lambda v: f"{v:.2f}".rstrip("0").rstrip("."))
    p.draw(pen)
    return pen.getCommands()


# --- Composition ------------------------------------------------------------
def build():
    spiral_h = cap * SPIRAL_HEIGHT

    # C, then the orange spiral as the o, its tail down to the right.
    c, x = text("C", 0, BASELINE_1)
    orange = place(fit(SPIRAL, SPIRAL_FLIP, spiral_h, angle=180), left=x + GAP, top=BASELINE_1 - cap)
    rest, _ = text("mplicity", orange.bounds[2] + GAP, BASELINE_1)

    # The green spiral as the G, under the o with its tail up to the left.
    green = place(fit(SPIRAL, SPIRAL_FLIP, spiral_h), left=orange.bounds[0], bottom=BASELINE_2 + 0.5)
    ame, x_end = text("ame", green.bounds[2] + GAP, BASELINE_2)

    bulb = place(
        fit(BULB, Transform(), cap * BULB_HEIGHT, angle=BULB_ANGLE),
        left=x_end + BULB_DX,
        bottom=BASELINE_2 + BULB_DY,
    )

    orange = dilate(orange, SPIRAL_THICKEN)
    green = dilate(green, SPIRAL_THICKEN)
    white = new()
    for p in (c, rest, ame):
        white = pathops.op(white, p, pathops.PathOp.UNION)

    everything = new()
    for p in (white, orange, green, bulb):
        everything = pathops.op(everything, p, pathops.PathOp.UNION)
    # Grown past the border and shrunk back, so the dips between letters fill
    # in; the holes are dropped at each step.
    border = outer_only(erode(outer_only(dilate(everything, BORDER + SOFTEN)), SOFTEN))

    x0, y0, x1, y1 = border.bounds
    w, h = x1 - x0 + 2 * PAD, y1 - y0 + 2 * PAD
    svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="{w:.2f}" height="{h:.2f}" viewBox="0 0 {w:.2f} {h:.2f}">
 <g transform="translate({PAD - x0:.2f} {PAD - y0:.2f})">
  <path d="{svg_d(border)}" fill="{INK}"/>
  <path d="{svg_d(white)}" fill="{WHITE}"/>
  <path d="{svg_d(orange)}" fill="{ORANGE}"/>
  <path d="{svg_d(green)}" fill="{GREEN}"/>
  <path d="{svg_d(bulb)}" fill="{YELLOW}"/>
 </g>
</svg>
'''
    return svg, f"{w:.2f}", f"{h:.2f}"


def write_og_image(svg_path):
    for tool in ("rsvg-convert", "magick"):
        if not shutil.which(tool):
            print(f"Skipped web/og-image.png: {tool} is not installed.")
            return
    with tempfile.TemporaryDirectory() as tmp:
        logo = Path(tmp) / "logo.png"
        subprocess.run(["rsvg-convert", "-w", str(OG_LOGO_WIDTH), str(svg_path), "-o", str(logo)], check=True)
        subprocess.run(
            [
                "magick", "-size", f"{OG_SIZE[0]}x{OG_SIZE[1]}", f"xc:{BACKGROUND}",
                str(logo), "-gravity", "center", "-composite", "-strip",
                f"PNG24:{ROOT / 'web/og-image.png'}",
            ],
            check=True,
        )
    print("Wrote web/og-image.png")


def main():
    svg, w, h = build()
    svg_path = ROOT / "assets/images/splash-icon.svg"
    svg_path.write_text(svg)
    print(f"Wrote {svg_path.relative_to(ROOT)} ({w} x {h})")

    widget = ROOT / "lib/widgets/game_logo.dart"
    source = widget.read_text()
    updated = re.sub(r"(_aspectRatio = )[\d.]+ / [\d.]+;", rf"\g<1>{w} / {h};", source)
    if updated != source:
        widget.write_text(updated)
        print(f"Updated the aspect ratio in {widget.relative_to(ROOT)}")

    write_og_image(svg_path)


if __name__ == "__main__":
    main()
