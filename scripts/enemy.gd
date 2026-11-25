class_name Enemy
extends CharacterBody2D

const SPEED := 45.0
const GRAVITY := 800.0

var dir := -1.0
var dead := false

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var floor_check: RayCast2D = $FloorCheck

func _ready() -> void:
	$Hurtbox.area_entered.connect(_on_stomped)
	sprite.play("walk")

func _physics_process(delta: float) -> void:
	if dead:
		return
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	elif is_on_wall() or not floor_check.is_colliding():
		dir = -dir
	velocity.x = dir * SPEED
	floor_check.position.x = 8.0 * dir
	sprite.flip_h = dir > 0.0
	move_and_slide()

func _on_stomped(area: Area2D) -> void:
	var player := area.owner as CharacterBody2D
	if dead or player.velocity.y <= 0.0:
		return
	dead = true
	player.bounce()
	sprite.stop()
	sprite.scale.y = 0.4
	sprite.position.y += 4.0
	$Hitbox.set_deferred("monitorable", false)
	create_tween().tween_property(self, "modulate:a", 0.0, 0.3)
	get_tree().create_timer(0.3).timeout.connect(queue_free)
