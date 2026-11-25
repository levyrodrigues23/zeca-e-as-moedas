class_name Coin
extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	$Sprite.play("spin")

func _on_body_entered(body: Node2D) -> void:
	body.add_coin()
	queue_free()
