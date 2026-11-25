class_name GameOver
extends Control

# Preenchidos pelo level.gd antes de trocar de cena.
static var reason := "Fim de jogo"
static var coins := 0
static var total_coins := 0

func _ready() -> void:
	$Box/Title.text = reason
	$Box/Score.text = "Moedas: %d/%d" % [coins, total_coins]
	$Box/Again.pressed.connect(_play_again)
	$Box/Again.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		_play_again()

func _play_again() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")
