extends Button

@onready var game = get_parent()

var dir: Vector2
var tapped: bool = false
var speed: float = 90

func calc_dir() -> Vector2:
	var x = randf_range(-1, 1)
	var y = randf_range(-1, 1)
	return Vector2(x, y).normalized()

func check_if_visible() -> bool:
	if position.x < 0 || position.y < 0:
		return false
	if position.x > 1055 || position.y > 576:
		return false
	
	return true

func _ready() -> void:
	dir = calc_dir()
	speed *= 1 + randf_range(-.33, .33)
	$Timer.wait_time = 1 + randf()

func _process(delta) -> void:
	if !check_if_visible() && !tapped:
		dir = position.direction_to(Vector2(467, 243)).normalized()
	
	position += dir * speed * delta

func _on_timer_timeout():
	if tapped: return
	dir = calc_dir()

func _on_pressed():
	dir = Vector2.DOWN
	tapped = true
	game.update_score()
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "speed", 9000, 10)
