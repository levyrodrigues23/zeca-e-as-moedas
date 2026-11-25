# Rodar: godot --headless --path . --script res://tests/test_game.gd
extends SceneTree

func _initialize() -> void:
	_run.call_deferred()

func _wait(frames: int) -> void:
	for i in frames:
		await physics_frame

func _run() -> void:
	change_scene_to_file("res://scenes/level.tscn")
	await _wait(5)
	var level := current_scene
	var player: CharacterBody2D = level.get_node("Player")

	# elementos instanciados por código
	assert(level.get_node("Coins").get_child_count() == level.COIN_CELLS.size(), "moedas não foram criadas")
	assert(level.get_children().filter(func(n): return n is Spike).size() == level.SPIKE_CELLS.size(), "espinhos")
	var enemies: Array = level.get_node("Enemies").get_children().filter(func(n): return n is Enemy)
	assert(enemies.size() == level.ENEMY_CELLS.size(), "inimigos")
	for a in ["walk", "jump", "hurt"]:
		assert(player.get_node("Sprite").sprite_frames.has_animation(a), "falta animação " + a)

	# moeda dá ponto
	var coin: Node2D = level.get_node("Coins").get_child(2)  # (15,7), sobre a plataforma, longe de espinho
	player.global_position = coin.global_position
	await _wait(3)
	assert(player.coins == 1, "moeda não contou")

	# pisar no inimigo mata e não tira vida
	var enemy: Enemy = enemies[1]  # no vale, sem plataforma em cima
	await _wait(1)
	player.global_position = enemy.global_position + Vector2(0, -30)
	player.velocity = Vector2.ZERO
	await _wait(30)
	assert(not is_instance_valid(enemy) or enemy.dead, "pisão não matou o inimigo")
	assert(player.lives == 3, "levou dano ao pisar")

	# espinho tira vida
	player.global_position = level._center(level.SPIKE_CELLS[1]) + Vector2(0, -20)
	player.velocity = Vector2.ZERO
	await _wait(30)
	assert(player.lives == 2, "espinho não tirou vida")

	# nave invoca bichinhos (Zeca parado e invencível no início enquanto espera)
	player.invincible = 60.0
	player.controllable = false
	player.global_position = Vector2(45, 180)
	var before: int = level.get_node("Enemies").get_child_count()
	await _wait(60 * 4)
	assert(level.get_node("Enemies").get_child_count() > before, "nave não invocou")

	# bandeira leva para a tela de fim de jogo
	player.invincible = 10.0
	player.global_position = level.get_node("Flag").global_position + Vector2(0, -10)
	await _wait(90)
	assert(current_scene is GameOver, "não abriu o Game Over")
	assert(GameOver.reason.begins_with("Você chegou"), "motivo errado")
	print("TESTES OK")
	quit()
