# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import argparse
from PIL import Image, ImageDraw, ImageFont


def create(text, bg_color, fg_color, file_name):
    W = 150
    H = 20
    image = Image.new("RGBA", (W, H), color=bg_color)
    draw = ImageDraw.Draw(image)

    font = ImageFont.load_default()
    w, h = font.getsize(text)
    draw.text(((W - w) / 2, (H - h) / 2), text, font=font, fill=fg_color)

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
        bg_color = 'rgb(149, 255, 128)'
        fg_color = 'rgb(0,0,0)'
    else:
        bg_color = 'rgb(255,191,179)'
        fg_color = 'rgb(0,0,0)'

    create(args.text, bg_color, fg_color, args.out)
