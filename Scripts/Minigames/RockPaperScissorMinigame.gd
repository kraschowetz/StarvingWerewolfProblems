extends Control

@export var icon: Sprite2D
@export var result: Label
@export var chance_label: Label
@export var textures: Array[Texture2D]

var can_play: bool = true
var chances: int = 3

func _ready() -> void:
	Global.in_minigame = true
	icon.scale = Vector2(3, 3)
	result.text = ""

func set_result(won: bool, spr: int, spr2: int, spr3) -> void:
	var tween = get_tree().create_tween()
	var scale_tween = get_tree().create_tween()
	
	chances -= 1
	
	if won:
		icon.texture = textures[spr]
		tween.tween_property(icon, "rotation", .45, .3)
		icon.self_modulate = Color("777777")
		result.text = "YOU WIN"
		result.self_modulate = Color(0, 1, 0, 1)
		Global.money += 3
		Global.change_money.emit()
	elif randi_range(0, 1) == 0:
		icon.texture = textures[spr3]
		tween.tween_property(icon, "rotation", .2, .3)
		icon.self_modulate = Color("ffffff")
		result.text = "TIE"
		result.self_modulate = Color("d69429")
		chances += 1
	else:
		icon.texture = textures[spr2]
		tween.tween_property(icon, "rotation", -.45, .3)
		icon.self_modulate = Color("ffffff")
		result.text = "YOU LOSE"
		result.self_modulate = Color(1, 0, 0, 1)
	scale_tween.tween_property(icon, "scale", Vector2(6, 6), .2)
	
	chance_label.text = "%s/3" % chances
	
	$Timer.start()
	can_play = false
	

func _on_button_pressed():
	if !can_play: return
	var won: bool = true if randi_range(1, 3) == 3 else false
	
	set_result(won, 2, 1, 0)
	

func _on_button_2_pressed():
	if !can_play: return
	var won: bool = true if randi_range(1, 3) == 3 else false
	
	set_result(won, 0, 2, 1)
	

func _on_button_3_pressed():
	if !can_play: return
	var won: bool = true if randi_range(1, 3) == 3 else false
	
	set_result(won, 1, 0, 2)
	

func _on_timer_timeout():
	var scale_tween = get_tree().create_tween()
	
	icon.texture = textures[0]
	result.text = ""
	icon.rotation = 0
	icon.self_modulate = Color("ffffff")
	can_play = true
	
	scale_tween.tween_property(icon, "scale", Vector2(3, 3), .2)
	
	if chances == 0:
		Global.in_minigame = false
		queue_free()
