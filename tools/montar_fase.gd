# Monta o terreno de scenes/level.tscn usando o AutoTile (terrain "grama").
# Rodar: godot --headless --path . --script tools/montar_fase.gd
# Pulo: sobe até 4 tiles e alcança ~4,5 tiles na horizontal, então degraus <= 3 e buracos <= 3.
extends SceneTree

const BOTTOM := 14
# [coluna inicial, coluna final, linha do topo]; colunas fora daqui são buracos.
const GROUND := [
	[0, 9, 11],              # início
	[13, 18, 11],            # depois do 1º buraco
	[19, 19, 10], [20, 20, 9], [21, 26, 8],  # escada até o platô
	[30, 41, 12],            # vale
	[45, 47, 10], [51, 53, 9],  # pilares sobre buracos
	[57, 66, 10],            # área da nave
	[67, 69, 11], [73, 78, 11],
	[79, 86, 8],             # paredão + parte alta
	[90, 93, 9],
	[94, 103, 11],           # chegada
]
# [coluna inicial, coluna final, linha]
const PLATFORMS := [[15, 17, 8], [33, 35, 9], [60, 63, 7], [82, 84, 5]]
# [coluna, linha, atlas x] — tufo 4, flor 5, cogumelo 6, pedra 8
const DECOS := [[4, 10, 5], [14, 10, 4], [22, 7, 6], [31, 11, 8], [40, 11, 5], [58, 9, 4],
	[68, 10, 6], [77, 10, 4], [81, 7, 8], [91, 8, 5], [95, 10, 4], [100, 10, 6]]

func _init() -> void:
	var packed: PackedScene = load("res://scenes/level.tscn")
	var level := packed.instantiate()
	var terreno: TileMapLayer = level.get_node("Terreno")
	terreno.clear()
	var cells: Array[Vector2i] = []
	for g in GROUND:
		for x in range(g[0], g[1] + 1):
			for y in range(g[2], BOTTOM + 1):
				cells.append(Vector2i(x, y))
	for p in PLATFORMS:
		for x in range(p[0], p[1] + 1):
			cells.append(Vector2i(x, p[2]))
	terreno.set_cells_terrain_connect(cells, 0, 0)
	for d in DECOS:
		terreno.set_cell(Vector2i(d[0], d[1]), 0, Vector2i(d[2], 6))
	# inimigos agora são criados pelo level.gd
	for e in level.get_node("Enemies").get_children():
		level.get_node("Enemies").remove_child(e)
		e.free()
	var out := PackedScene.new()
	assert(out.pack(level) == OK)
	assert(ResourceSaver.save(out, "res://scenes/level.tscn") == OK)
	print("fase montada: %d tiles" % cells.size())
	quit()
