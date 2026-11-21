extends SceneTree

func _init() -> void:
	var level: Node = load("res://scenes/level.tscn").instantiate()
	root.add_child(level)
	await process_frame
	var player: CharacterBody2D = level.get_node("Player")
	var enemy: CharacterBody2D = level.get_node("Enemies/Enemy5")
	await frames(10)

	player.invincible = 99.0
	for edge in [12, 35, 73]:
		player.global_position = Vector2(edge * 18 - 40, player.global_position.y)
		player.global_position.y = 0.0
		await frames(60)
		var before: int = player.coins
		Input.action_press("move_right")
		while player.global_position.x < edge * 18 - 4:
			await physics_frame
		Input.action_press("jump")
		await frames(2)
		Input.action_release("jump")
		await frames(50)
		Input.action_release("move_right")
		assert(player.coins == before + 1, "moeda do buraco %d não foi pega no pulo" % edge)
	player.coins = 0
	player.invincible = 0.0

	player.global_position = enemy.global_position + Vector2(0, -40)
	await frames(30)
	assert(not is_instance_valid(enemy) or enemy.dead, "pisão não matou o inimigo")
	assert(player.lives == 3, "levou dano ao pisar")

	enemy = level.get_node("Enemies/Enemy7")
	player.global_position = enemy.global_position + Vector2(-4, -4)
	await frames(5)
	assert(player.lives == 2, "encostar no inimigo não tirou vida")

	await frames(70)
	var coin: Node2D = level.get_node("Coins/Coin1")
	var coins_before: int = player.coins
	player.global_position = coin.global_position
	await frames(5)
	assert(player.coins == coins_before + 1, "moeda não contou")

	var flag: Node2D = level.get_node("Flag")
	player.global_position = flag.global_position + Vector2(0, -10)
	await frames(5)
	var message: Label = level.get_node("HUD/Message")
	assert(message.visible and message.text.begins_with("Você chegou"), "chegada não terminou a fase")
	print("OK test_game")
	quit()

func frames(n: int) -> void:
	for i in n:
		await physics_frame
