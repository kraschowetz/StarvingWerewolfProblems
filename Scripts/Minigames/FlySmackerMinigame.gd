extends Control

@export var score_label: Label
@export var timer_label: Label
@export var fly: PackedScene

var score: int = 0
var time = 10

func update_score() -> void:
	score += 1
	var _t = "score: %s" % score if score > 10 else "score: 0%s" % score
	score_label.text = _t


func _on_timer_timeout():
	var f = fly.instantiate()
	if randf() < .5:
		f.position = Vector2(-20, randi_range(0, 576))
	else:
		f.position = Vector2(randi_range(0, 1056), -20)
	add_child(f)

func _on_exit_timer_timeout():
	time -= 1
	timer_label.text = "%s" % time if time > 10 else "0%s" % time
	if time < 0:
		Global.in_minigame = false
		Global.money += score / 2
		Global.change_money.emit()
		queue_free()
