extends Node2D

@export var bar: TextureRect
@export var label: Label
@export var title: Label
@export var fame: Label

func _ready() -> void:
	var i: int = 0 if Global.current_trans_data[1] == "DEBT" else 1
	
	if i == 1:
		fame.text = "%s" % Global.popularity + "% fame   " + "%s" % Global.fear +"% infamy" 
	
	bar.size.y = 288 / (100 / Global.last_trans_val[i])
	print(Global.last_trans_val[i])
	
	var tween = get_tree().create_tween()
	tween.finished.connect(on_tween_fineshed)
	
	label.text = Global.current_trans_data[1]
	title.text = Global.current_trans_data[3]
	
	var n = 288 / (100 / Global.current_trans_data[0].to_float())
	
	tween.tween_property(bar, "size", Vector2(96, n), 1)
	Global.last_trans_val[i] = Global.current_trans_data[0].to_int()

func on_tween_fineshed() -> void:
	await get_tree().create_timer(2).timeout
	if Global.current_trans_data[1] == "DEBT":
		get_tree().call_deferred("change_scene_to_file", Global.current_trans_data[2])
	else:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/NewsPaper.tscn")
