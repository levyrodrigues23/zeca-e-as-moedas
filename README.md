# Zeca e as Moedas

Demo de plataforma 2D em Godot 4.7. Zeca, um alienzinho de capacete, cai num planeta de grama invadido pelos bichinhos azuis que uma nave vai soltando. Ele precisa chegar na bandeira pegando moedas, pisando nos bichinhos e desviando dos espinhos.

Feito por José Levy Rodrigues da Silva.

## Como jogar

Abrir o projeto no Godot 4.7 e rodar (F5).

| Ação | Teclas |
|---|---|
| Andar | A / D ou ← / → |
| Pular | Espaço, W ou ↑ |
| Reiniciar | R |

## Teste

```
godot --headless --path . --script res://tests/test_game.gd
```

## Ferramentas

- `python tools/gerar_arte.py`: gera a arte (`assets/tiles.png` e `assets/characters.png`).
- `godot --headless --path . --script tools/montar_fase.gd`: monta o terreno da fase com o AutoTile.

## Documentos

- [GDD](docs/GDD.md)
- [Respostas da entrega](docs/entrega.md)
- [Créditos](CREDITS.md)
