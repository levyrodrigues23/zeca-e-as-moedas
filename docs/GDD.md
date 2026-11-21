# GDD — Zeca e as Moedas

Plataforma 2D curto (1 a 2 minutos), feito em Godot 4.7 para PC.

## Como joga

- Zeca anda, pula e tem 3 vidas.
- Encostar num bichinho azul tira 1 vida (Zeca fica piscando 1 segundo).
- Pular na cabeça do bichinho derrota ele e dá um quique.
- Moedas espalhadas pela fase, com contador no canto.
- A fase acaba ao tocar na bandeira, perder as 3 vidas ou cair num buraco. R reinicia.

## Requisitos da demo

| Pedido | Onde está |
|---|---|
| Personagem CharacterBody2D | `scenes/player.tscn` |
| Camera2D | filha do Player, com suavização e limites da fase |
| TileMap com física | `TileMapLayer` com camada de colisão nos tiles |
| Autotileset | terrain "grama" (16 combinações de bordas) em `assets/tileset.tres` |
| Inimigo com hurtbox | `Hurtbox` na cabeça do bichinho, recebe o pisão do Zeca |
| Inimigo com hitbox | `Hitbox` no corpo do bichinho, tira vida do Zeca |
| Extra | moedas com contador e vidas no HUD |

## Arte

Kenney Pixel Platformer (CC0) e fonte Pixelify Sans (OFL).
