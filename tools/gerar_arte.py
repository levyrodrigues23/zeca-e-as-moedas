"""Gera assets/tiles.png e assets/characters.png (arte autoral, feita com auxílio de IA).

Mantém o mesmo layout de atlas que tileset.tres e as cenas usam.
Rodar da raiz do projeto: python tools/gerar_arte.py
"""
import re
from PIL import Image, ImageDraw

T = 18  # tamanho do tile
C = 24  # tamanho do quadro de personagem

GRASS_TIP, GRASS, GRASS_DARK = (142, 224, 90), (94, 196, 66), (52, 140, 47)
DIRT, DIRT_LIGHT, DIRT_DARK, OUTLINE = (138, 90, 60), (168, 113, 74), (110, 68, 48), (59, 36, 24)


def px(d, x, y, c):
    d.point((x, y), fill=c)


def terrain(img, cx, cy, sides):
    d = ImageDraw.Draw(img)
    ox, oy = cx * T, cy * T
    d.rectangle((ox, oy, ox + T - 1, oy + T - 1), fill=DIRT)
    for i in range(7):  # pedrinhas fixas, iguais em todos os tiles para emendar bem
        x, y = (i * 7 + 3) % 16 + 1, (i * 11 + 5) % 16 + 1
        px(d, ox + x, oy + y, DIRT_LIGHT if i % 2 else DIRT_DARK)
    if "left" not in sides:
        d.line((ox, oy, ox, oy + T - 1), fill=OUTLINE)
        d.line((ox + 1, oy, ox + 1, oy + T - 1), fill=DIRT_DARK)
    if "right" not in sides:
        d.line((ox + T - 1, oy, ox + T - 1, oy + T - 1), fill=OUTLINE)
        d.line((ox + T - 2, oy, ox + T - 2, oy + T - 1), fill=DIRT_DARK)
    if "bottom" not in sides:
        d.line((ox, oy + T - 1, ox + T - 1, oy + T - 1), fill=OUTLINE)
        d.line((ox, oy + T - 2, ox + T - 1, oy + T - 2), fill=DIRT_DARK)
    if "top" not in sides:
        d.rectangle((ox, oy, ox + T - 1, oy + 4), fill=GRASS)
        for x in range(T):
            px(d, ox + x, oy, GRASS_TIP if x % 3 else GRASS)
            px(d, ox + x, oy + 5, GRASS_DARK)
            if x % 4 == 1:
                px(d, ox + x, oy + 6, GRASS_DARK)
        if "left" not in sides:
            d.line((ox, oy, ox, oy + 5), fill=GRASS_DARK)
            px(d, ox, oy, (0, 0, 0, 0))
        if "right" not in sides:
            d.line((ox + T - 1, oy, ox + T - 1, oy + 5), fill=GRASS_DARK)
            px(d, ox + T - 1, oy, (0, 0, 0, 0))
    if "bottom" not in sides and "left" not in sides:
        px(d, ox, oy + T - 1, (0, 0, 0, 0))
    if "bottom" not in sides and "right" not in sides:
        px(d, ox + T - 1, oy + T - 1, (0, 0, 0, 0))


def cell(cx, cy):
    return cx * T, cy * T


def tiles():
    img = Image.new("RGBA", (360, 162), (0, 0, 0, 0))
    src = open("assets/tileset.tres", encoding="utf-8").read()
    for cx, cy in set(re.findall(r"^(\d+):(\d+)/0/terrain = 0", src, re.M)):
        sides = set(re.findall(rf"^{cx}:{cy}/0/terrains_peering_bit/(\w+)_side", src, re.M))
        terrain(img, int(cx), int(cy), sides)
    d = ImageDraw.Draw(img)

    # decorações (4,6) tufo, (5,6) flor, (6,6) cogumelo alienígena, (8,6) pedra
    x, y = cell(4, 6)
    for i, h in enumerate((4, 7, 5, 8, 4)):
        d.line((x + 5 + i * 2, y + 17, x + 5 + i * 2, y + 17 - h), fill=GRASS if i % 2 else GRASS_DARK)
    x, y = cell(5, 6)
    d.line((x + 9, y + 17, x + 9, y + 10), fill=GRASS_DARK)
    d.ellipse((x + 6, y + 5, x + 12, y + 11), fill=(240, 120, 190))
    d.rectangle((x + 8, y + 7, x + 10, y + 9), fill=(255, 230, 90))
    x, y = cell(6, 6)
    d.rectangle((x + 8, y + 12, x + 10, y + 17), fill=(230, 220, 200))
    d.pieslice((x + 4, y + 6, x + 14, y + 16), 180, 360, fill=(150, 80, 220))
    px(d, x + 7, y + 8, (220, 190, 255)); px(d, x + 11, y + 9, (220, 190, 255))
    x, y = cell(8, 6)
    d.ellipse((x + 3, y + 10, x + 15, y + 18), fill=(130, 130, 145), outline=(80, 80, 95))
    px(d, x + 6, y + 12, (175, 175, 190))

    # coração (4,2) para a HUD
    x, y = cell(4, 2)
    red, dark = (230, 50, 70), (140, 20, 40)
    d.ellipse((x + 2, y + 3, x + 9, y + 10), fill=red)
    d.ellipse((x + 8, y + 3, x + 15, y + 10), fill=red)
    d.polygon([(x + 2, y + 8), (x + 15, y + 8), (x + 8, y + 15)], fill=red)
    d.point([(x + 5, y + 5), (x + 4, y + 6)], fill=(255, 170, 180))
    d.line((x + 8, y + 15, x + 15, y + 8), fill=dark)

    # moeda girando (11,7) e (12,7)
    gold, shine, edge = (250, 200, 40), (255, 245, 150), (190, 130, 20)
    x, y = cell(11, 7)
    d.ellipse((x + 4, y + 4, x + 13, y + 13), fill=gold, outline=edge)
    d.line((x + 8, y + 6, x + 8, y + 11), fill=edge)
    px(d, x + 6, y + 6, shine)
    x, y = cell(12, 7)
    d.ellipse((x + 6, y + 4, x + 11, y + 13), fill=gold, outline=edge)
    d.line((x + 8, y + 6, x + 8, y + 11), fill=shine)

    # bandeira: mastro (11,6), pano em 2 quadros (11,5) e (12,5)
    pole, knob = (200, 200, 210), (255, 220, 60)
    x, y = cell(11, 6)
    d.rectangle((x + 8, y, x + 9, y + 17), fill=pole)
    d.rectangle((x + 6, y + 16, x + 11, y + 17), fill=(120, 120, 130))
    for i, cx in enumerate((11, 12)):
        x, y = cell(cx, 5)
        d.rectangle((x + 8, y + 2, x + 9, y + 17), fill=pole)
        d.ellipse((x + 7, y, x + 10, y + 3), fill=knob)
        wave = (0, 1, 1, 0, -1, -1, 0, 1) if i == 0 else (1, 0, -1, -1, 0, 1, 1, 0)
        for k, w in enumerate(wave):
            d.line((x + 10 + k, y + 3 + w, x + 10 + k, y + 10 + w), fill=(240, 70, 70) if k < 7 else (180, 40, 40))

    # espinho (14,7): obstáculo que tira vida
    x, y = cell(14, 7)
    for k in range(3):
        bx = x + 1 + k * 6
        d.polygon([(bx, y + 17), (bx + 5, y + 17), (bx + 2, y + 8)], fill=(200, 205, 220), outline=(90, 95, 115))
    d.rectangle((x, y + 16, x + 17, y + 17), fill=(90, 95, 115))
    # nave dos bichinhos (16,7)-(17,7), 36x18
    x, y = cell(16, 7)
    d.ellipse((x + 11, y + 1, x + 24, y + 11), fill=(170, 230, 255), outline=(90, 160, 210))
    d.ellipse((x + 1, y + 7, x + 34, y + 15), fill=(160, 160, 180), outline=(80, 80, 100))
    for k in range(4):
        d.rectangle((x + 7 + k * 7, y + 10, x + 8 + k * 7, y + 11), fill=(255, 220, 60))
    d.polygon([(x + 13, y + 15), (x + 22, y + 15), (x + 24, y + 17), (x + 11, y + 17)], fill=(80, 80, 100))
    img.save("assets/tiles.png")


def zeca(d, ox, legs, hurt=False, arms_up=False):
    """Zeca olhando para a esquerda (o script espelha para a direita)."""
    suit = (240, 120, 50) if not hurt else (240, 60, 60)
    skin = (120, 210, 90) if not hurt else (230, 110, 110)
    # pernas
    for lx, ly in legs:
        d.rectangle((ox + lx, ly, ox + lx + 2, 23), fill=(70, 70, 90))
    # corpo
    d.rectangle((ox + 8, 14, ox + 15, 20), fill=suit, outline=(120, 50, 20))
    d.line((ox + 9, 17, ox + 14, 17), fill=(255, 210, 90))
    # braços
    if arms_up:
        d.line((ox + 7, 14, ox + 6, 11), fill=suit, width=2)
        d.line((ox + 16, 14, ox + 17, 11), fill=suit, width=2)
    else:
        d.line((ox + 7, 15, ox + 6, 19), fill=suit, width=2)
        d.line((ox + 16, 15, ox + 17, 19), fill=suit, width=2)
    # cabeça + capacete de vidro
    d.ellipse((ox + 7, 4, ox + 16, 13), fill=skin)
    d.line((ox + 12, 4, ox + 13, 1), fill=skin)
    px(d, ox + 13, 1, (255, 230, 90))
    if hurt:
        for ex in (9, 12):
            d.line((ox + ex, 7, ox + ex + 2, 9), fill=(40, 20, 20))
            d.line((ox + ex, 9, ox + ex + 2, 7), fill=(40, 20, 20))
    else:
        d.rectangle((ox + 8, 6, ox + 11, 9), fill=(255, 255, 255))
        d.rectangle((ox + 8, 7, ox + 9, 9), fill=(20, 20, 40))
    d.ellipse((ox + 5, 2, ox + 18, 15), outline=(170, 230, 255))
    px(d, ox + 8, 4, (255, 255, 255)); px(d, ox + 7, 5, (255, 255, 255))


def bicho(d, ox, oy, squash):
    body, dark = (70, 140, 240), (30, 70, 160)
    top = 13 + squash
    d.ellipse((ox + 4, top, ox + 19 + squash, 22), fill=body, outline=dark)
    d.ellipse((ox + 6, top + 2, ox + 10, top + 6), fill=(255, 255, 255))
    d.rectangle((ox + 6, top + 3, ox + 7, top + 5), fill=(20, 20, 40))
    d.ellipse((ox + 11, top + 2, ox + 15, top + 6), fill=(255, 255, 255))
    d.rectangle((ox + 11, top + 3, ox + 12, top + 5), fill=(20, 20, 40))
    d.rectangle((ox + 6, 22, ox + 8, 23), fill=dark)
    d.rectangle((ox + 14 + squash, 22, ox + 16 + squash, 23), fill=dark)


def characters():
    img = Image.new("RGBA", (216, 72), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    zeca(d, 0, [(8, 21), (13, 21)])               # walk 1
    zeca(d, 24, [(9, 21), (12, 20)])              # walk 2
    zeca(d, 48, [(8, 20), (13, 20)], arms_up=True)  # jump (ver abaixo)
    d.rectangle((48 + 8, 22, 48 + 15, 23), fill=(0, 0, 0, 0))  # pernas encolhidas no pulo
    zeca(d, 72, [(8, 21), (13, 21)], hurt=True)   # hurt
    sub = Image.new("RGBA", (216, 24), (0, 0, 0, 0))
    ds = ImageDraw.Draw(sub)
    bicho(ds, 0, 0, 0)
    bicho(ds, 24, 0, 2)
    img.paste(sub, (0, 48), sub)
    img.save("assets/characters.png")


if __name__ == "__main__":
    tiles()
    characters()
    a, b = Image.open("assets/tiles.png"), Image.open("assets/characters.png")
    assert a.size == (360, 162) and b.size == (216, 72)
    assert a.getpixel((0 * T + 9, 0 * T + 2))[3] == 255, "tile de terreno (0,0) vazio"
    print("ok")
