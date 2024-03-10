extends Node2D

@onready var area: Area2D = $Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label
@onready var player: CharacterBody2D = get_node("../Player")

@export var minigame: PackedScene

var selected: bool = false
var closed: bool = false
var icon_dir: int = 1

func _ready() -> void:
	area.mouse_entered.connect(on_mouse_entered)
	area.mouse_exited.connect(on_mouse_exited)
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(label, "position", Vector2(-11, -65 + (6 * icon_dir)), 1)
	icon_dir *= -1

func _process(_delta) -> void:
	sprite.z_index = position.y
	
	if closed: return
	if !selected: return
	if !Input.is_action_just_released("lmb"): return
	if Global.in_minigame: return
	
	var game = minigame.instantiate()
	Global.in_minigame = true
	closed = true
	label.visible = false
	get_node("../CanvasLayer").call_deferred("add_child", game)

func on_mouse_entered() -> void:
	selected = true

func on_mouse_exited() -> void:
	selected = false

func _on_timer_timeout():
	var tween = get_tree().create_tween()
	
	tween.tween_property(label, "position", Vector2(-11, -65 + (6 * icon_dir)), 1)
	icon_dir *= -1
