extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: int = 300

var dir: Vector2 = Vector2.ZERO
var prev_dir = Vector2.RIGHT

func _ready() -> void:
	if Global.player_position == Vector2.ZERO: return
	$Camera2D.position_smoothing_enabled = false
	position = Global.player_position
	await get_tree().create_timer(.1).timeout
	$Camera2D.position_smoothing_enabled = true

func handle_animations() -> void:
	if dir != Vector2.ZERO:
		prev_dir = dir
	
	if prev_dir.x != 0 && prev_dir.y != 0:
		prev_dir.y = 0
	
	sprite.flip_h = true if prev_dir == Vector2.LEFT else false
	sprite.z_index = position.y
	
	if velocity == Vector2.ZERO:
		match prev_dir:
			Vector2.UP:
				sprite.play("IdleUp")
			Vector2.DOWN:
				sprite.play("IdleDown")
			Vector2.RIGHT:
				sprite.play("IdleSide")
			Vector2.LEFT:
				sprite.play("IdleSide")
	else:
		match prev_dir:
			Vector2.UP:
				sprite.play("WalkUp")
			Vector2.DOWN:
				sprite.play("WalkDown")
			Vector2.RIGHT:
				sprite.play("WalkSide")
			Vector2.LEFT:
				sprite.play("WalkSide")
	

func _process(_delta) -> void:
	
	dir.x = Input.get_axis("a", "d")
	dir.y = Input.get_axis("w", "s")
	
	velocity = dir.normalized() * speed
	
	handle_animations()
	
	if !Global.in_minigame:
		move_and_slide()


func _on_timer_timeout():
	Global.player_position = position
