extends Node2D

# Nave que invoca bichinhos: solta um a cada INTERVAL segundos, com no máximo MAX_ALIVE vivos.
const ENEMY_SCENE := preload("res://scenes/enemy.tscn")
const INTERVAL := 3.5
const MAX_ALIVE := 3
const HOVER := 60.0

var spawned: Array[Enemy] = []

func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = INTERVAL
	timer.timeout.connect(_drop)
	add_child(timer)
	timer.start()
	var tween := create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:x", position.x + HOVER, 2.0)
	tween.tween_property(self, "position:x", position.x - HOVER, 2.0)

func _drop() -> void:
	spawned = spawned.filter(func(e: Enemy) -> bool: return is_instance_valid(e) and not e.dead)
	if spawned.size() >= MAX_ALIVE:
		return
	var enemy: Enemy = ENEMY_SCENE.instantiate()
	enemy.position = position + Vector2(0, 14)
	get_parent().add_child(enemy)
	spawned.append(enemy)
