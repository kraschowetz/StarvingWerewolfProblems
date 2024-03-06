extends Control

@export var bar: TextureRect
@export var path: String

func _ready() -> void:
	var tween: Tween = get_tree().create_tween()
	var t: int = 1 if get_tree().current_scene.name == "Day" else 2
	tween.tween_property(bar, "size", Vector2(0, 16), 30 * t)
	tween.finished.connect(on_timeout)

func on_timeout() -> void:
	Global.in_minigame = false
	if get_tree().current_scene.name == "Night":
		Global.day += 1
		Global.hunger += 10 + randi_range(0, 15)
		Global.current_trans_data = ["%s" % Global.hunger, "HUNGER", path, "THE SUN RISES"]
	else:
		Global.debt += 10 + randi_range(0, 15)
		Global.current_trans_data = ["%s" % Global.debt, "DEBT", path, "THE SUN FALLS"]
	
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Transition.tscn")
