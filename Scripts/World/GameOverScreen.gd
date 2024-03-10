extends Node2D

@export var main: Label
@export var sub: Label

func _input(event) -> void:
	if event is InputEventMouseMotion: return
	
	Global.spotted_lvl = 0
	Global.hunger = 0
	Global.money = 0
	Global.debt = 50
	
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Day.tscn")
	

func _ready() -> void:
	if Global.hunger >= 100:
		main.text = "YOU STARVED TO DEATH"
		sub.text = "the hunger consumed you"
	else:
		main.text = "YOU GOT KICKED OUT OF YOUR HOUSE"
		sub.text = "the debt consumed you"
