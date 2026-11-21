extends CharacterBody2D

signal lives_changed(lives: int)
signal coins_changed(coins: int)
signal died

const SPEED := 100.0
const JUMP_VELOCITY := -340.0
const GRAVITY := 800.0
const BOUNCE_VELOCITY := -220.0
const INVINCIBLE_TIME := 1.0

var lives := 3
var coins := 0
var invincible := 0.0
var controllable := true

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hurtbox: Area2D = $Hurtbox

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	var dir := Input.get_axis("move_left", "move_right") if controllable else 0.0
	velocity.x = dir * SPEED
	if controllable and is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
	move_and_slide()
	if dir != 0.0:
		sprite.flip_h = dir > 0.0
	if not is_on_floor():
		sprite.stop()
		sprite.frame = 1
	elif dir != 0.0:
		sprite.play("walk")
	else:
		sprite.stop()
		sprite.frame = 0
	invincible = maxf(invincible - delta, 0.0)
	sprite.visible = invincible == 0.0 or int(invincible * 12.0) % 2 == 0
	if invincible == 0.0 and lives > 0:
		for area in hurtbox.get_overlapping_areas():
			if not area.owner.dead:
				take_hit()
				break

func bounce() -> void:
	velocity.y = BOUNCE_VELOCITY

func add_coin() -> void:
	coins += 1
	coins_changed.emit(coins)

func take_hit() -> void:
	lives -= 1
	lives_changed.emit(lives)
	invincible = INVINCIBLE_TIME
	velocity.y = BOUNCE_VELOCITY
	if lives == 0:
		controllable = false
		died.emit()
