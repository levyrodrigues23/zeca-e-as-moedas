extends Node2D

const FALL_LIMIT := 300.0
const END_DELAY := 1.0
const TILE := 18
const COIN_SCENE := preload("res://scenes/coin.tscn")
const SPIKE_SCENE := preload("res://scenes/spike.tscn")
const ENEMY_SCENE := preload("res://scenes/enemy.tscn")
const UFO_SCENE := preload("res://scenes/ufo.tscn")
# Posições em tiles (coluna, linha), na célula vazia logo acima do chão. Mapa em tools/montar_fase.gd.
const COIN_CELLS: Array[Vector2i] = [
	Vector2i(6, 8), Vector2i(11, 8), Vector2i(15, 7), Vector2i(16, 7), Vector2i(17, 7),
	Vector2i(24, 5), Vector2i(28, 6), Vector2i(33, 8), Vector2i(35, 8), Vector2i(43, 8),
	Vector2i(46, 8), Vector2i(49, 6), Vector2i(52, 7), Vector2i(55, 6), Vector2i(61, 6),
	Vector2i(62, 6), Vector2i(68, 10), Vector2i(71, 8), Vector2i(76, 10), Vector2i(83, 4),
	Vector2i(88, 6), Vector2i(92, 8), Vector2i(99, 10),
]
const SPIKE_CELLS: Array[Vector2i] = [
	Vector2i(6, 10), Vector2i(24, 7), Vector2i(37, 11), Vector2i(64, 9), Vector2i(75, 10), Vector2i(97, 10),
]
const ENEMY_CELLS: Array[Vector2i] = [
	Vector2i(16, 10), Vector2i(38, 11), Vector2i(59, 9), Vector2i(65, 9), Vector2i(76, 10),
	Vector2i(84, 7), Vector2i(99, 10),
]
const UFO_POSITION := Vector2(1125, 40)

var finished := false
var total_coins := 0

@onready var player: CharacterBody2D = $Player
@onready var hearts: Array[Node] = $HUD/Bar/Hearts.get_children()
@onready var coin_label: Label = $HUD/Bar/Coins

func _ready() -> void:
	for c in COIN_CELLS:
		_spawn(COIN_SCENE, $Coins, _center(c))
	for c in SPIKE_CELLS:
		_spawn(SPIKE_SCENE, self, _center(c))
	for c in ENEMY_CELLS:
		_spawn(ENEMY_SCENE, $Enemies, _center(c) + Vector2(0, 4))  # pés do bichinho no chão
	_spawn(UFO_SCENE, $Enemies, UFO_POSITION)
	total_coins = COIN_CELLS.size()
	player.lives_changed.connect(_on_lives_changed)
	player.coins_changed.connect(_on_coins_changed)
	player.died.connect(_end.bind("Fim de jogo"))
	$Flag.body_entered.connect(func(_body: Node2D) -> void: _end("Você chegou!"))
	_on_coins_changed(0)

func _center(cell: Vector2i) -> Vector2:
	return Vector2(cell * TILE) + Vector2(TILE, TILE) / 2.0

func _spawn(scene: PackedScene, parent: Node, pos: Vector2) -> void:
	var node: Node2D = scene.instantiate()
	node.position = pos
	parent.add_child(node)

func _physics_process(_delta: float) -> void:
	if not finished and player.global_position.y > FALL_LIMIT:
		_end("Caiu!")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

func _on_lives_changed(lives: int) -> void:
	for i in hearts.size():
		hearts[i].modulate.a = 1.0 if i < lives else 0.25

func _on_coins_changed(coins: int) -> void:
	coin_label.text = "%d/%d" % [coins, total_coins]

func _end(text: String) -> void:
	if finished:
		return
	finished = true
	player.controllable = false
	GameOver.reason = text
	GameOver.coins = player.coins
	GameOver.total_coins = total_coins
	await get_tree().create_timer(END_DELAY).timeout
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
