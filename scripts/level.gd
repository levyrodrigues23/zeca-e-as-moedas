extends Node2D

const FALL_LIMIT := 300.0

var finished := false

@onready var player: CharacterBody2D = $Player
@onready var hearts: Array[Node] = $HUD/Bar/Hearts.get_children()
@onready var coin_label: Label = $HUD/Bar/Coins
@onready var message: Label = $HUD/Message
@onready var total_coins: int = $Coins.get_child_count()

func _ready() -> void:
	player.lives_changed.connect(_on_lives_changed)
	player.coins_changed.connect(_on_coins_changed)
	player.died.connect(_end.bind("Fim de jogo"))
	$Flag.body_entered.connect(func(_body: Node2D) -> void: _end("Você chegou!"))
	_on_coins_changed(0)
	message.visible = false

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
	message.text = "%s\nMoedas: %d/%d\nR para jogar de novo" % [text, player.coins, total_coins]
	message.visible = true
