extends Node2D

@onready var spawn_timer = $SpawnTimer

@export var civilian_target_pos: Array[Vector2]
@export var civilian_start_pos: Array[Vector2]
@export var guard: PackedScene
@export var civilian: PackedScene
@export var journalist: PackedScene

var npc_queue: Array[PackedScene]
var current_queue_pos: int = 0

func _ready() -> void:
	var n: int = randi_range(2, 4) + (1.5 * (Global.popularity / 5))
	
	for i in range(n):
		if randi_range(1, 100) < (15 if Global.popularity < 45 else Global.popularity) || Global.popularity < 1:
			npc_queue.append(journalist)
			if Global.popularity < 1:
				Global.popularity += 1
			continue
		if randi_range(1, 100) < (20 if Global.fear < 40 else Global.fear / 2):
			npc_queue.append(guard)
			continue
		npc_queue.append(civilian)

func _on_spawn_timer_timeout():
	if current_queue_pos >= npc_queue.size(): return
	
	var npc = npc_queue[current_queue_pos].instantiate()
	npc.position = civilian_start_pos[randi_range(0, civilian_start_pos.size() - 1)]
	call_deferred("add_child", npc)
	current_queue_pos += 1
