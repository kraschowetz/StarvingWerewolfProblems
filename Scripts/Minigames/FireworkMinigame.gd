extends Control

@export var person: PackedScene
@export var firework: PackedScene

var person_list: Array[AnimatedSprite2D]
var firework_list: Array[Button]
var ammount: int = 3
var popped: int = 0
var missed: int = 0

func _ready() -> void:
	$Timer.wait_time *= 1 + randf_range(-.25, .25)
	ammount += Global.day / 3
	
	for i in range(ammount):
		var p = person.instantiate()
		p.position = Vector2((i + 1) * 100,527)
		person_list.append(p)
		add_child(p)

func check_total() -> void:
	if popped + missed < ammount: return
	
	if missed == 0:
		Global.money += 10 + ammount - 3
		Global.change_money.emit()
	else:
		Global.money += popped
		
	await get_tree().create_timer(1).timeout
	
	Global.in_minigame = false
	queue_free()

func on_firework_popped(_id: int) -> void:
	person_list[_id].play("Happy")
	popped += 1
	check_total()

func on_firework_escape(_id: int) -> void:
	person_list[_id].play("Sad")
	person_list[_id].self_modulate = Color("777777")
	missed += 1
	check_total()

func _on_timer_timeout():
	if firework_list.size() == person_list.size(): return
	
	var f = firework.instantiate()
	f.position = Vector2(randi_range(500, 1044), 576)
	f.popped.connect(on_firework_popped)
	f.escaped.connect(on_firework_escape)
	firework_list.append(f)
	f.id = firework_list.size() - 1
	add_child(f)
