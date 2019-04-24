# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import argparse
import os
from PIL import Image, ImageDraw, ImageFont

THIS_DIR = os.path.dirname(os.path.realpath(__file__))


def create(result, text, bg_color, fg_color, file_name):
    W = 130
    H = 20
    image = Image.new("RGBA", (2*W, H), color=bg_color)
    draw = ImageDraw.Draw(image)

    fontpath = os.path.join(THIS_DIR, "Roboto", "Roboto-Black.ttf")
    if not os.path.exists(fontpath):
        raise Exception("font " + fontpath + " missing")

    font = ImageFont.truetype(fontpath)
    w1, h1 = font.getsize(text)
    draw.polygon([0, 0, W, 0, W, H, 0, H, 0, 0], fill="black")
    draw.text(((W - w1) / 2, (H - h1) / 2), text, font=font, fill=fg_color)

    w2, h2 = font.getsize(result)
    draw.text((W + (W - w2) / 2, (H - h2) / 2), result, font=font, fill=fg_color)

    image.save(file_name)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Create status image')
    parser.add_argument('--text',
                        required=True)
    parser.add_argument('--success',
                        action='store_true',
                        required=False,
                        default=False)
    parser.add_argument('--out')
    args = parser.parse_args()

    if args.success:
        bg_color = 'rgb(75, 197, 29)'
        fg_color = 'rgb(255,255,255)'
        result = "passing"
    else:
        bg_color = 'rgb(211, 94, 71)'
        fg_color = 'rgb(255,255,255)'
        result = "failing"

    create(result, args.text, bg_color, fg_color, args.out)
