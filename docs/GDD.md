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
| Autotileset | terrain "grama" (16 combinações de bordas) em `assets/tileset.tres`; terreno montado com `set_cells_terrain_connect` em `tools/montar_fase.gd` |
| Inimigo com hurtbox | `Hurtbox` na cabeça do bichinho, recebe o pisão do Zeca |
| Inimigo com hitbox | `Hitbox` no corpo do bichinho, tira vida do Zeca |
| Itens | moeda (+1 ponto) e espinho (-1 vida) |
| Instanciado por código | `Coin` e `Spike` criados em laço no `level.gd`; a nave (`ufo.tscn`) invoca um `Enemy` a cada 3,5 s (máx. 3) |
| Game Over | `scenes/game_over.tscn` com nome, créditos e botão para voltar |
| HUD | moedas com contador e vidas |

## Arte

Autoral, gerada por `tools/gerar_arte.py` com auxílio de IA. Fonte Pixelify Sans (OFL).
