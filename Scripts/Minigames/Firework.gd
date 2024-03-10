extends Button

@export var fx: PackedScene

var speed: int = 120
var id: int = 0
var has_escaped: bool = false

signal popped(_id: int)
signal escaped(_id: int)

func _ready() -> void:
	speed *= 1 + randf_range(-.3, .3)

func _process(delta) -> void:
	position += Vector2.UP * speed * delta;
	if position.y < -24 && !has_escaped:
		escaped.emit(id)
		has_escaped = true

func _on_pressed():
	if speed < 1: return
	speed = 0
	popped.emit(id)
	var f = fx.instantiate()
	f.position = Vector2(12, 12)
	add_child(f)
	icon = null
