extends Node2D

@export var quest_givers: Array[PackedScene]
@export var possible_pos: Array[Vector2]

var used_positions: Array[int]

func _ready() -> void:
	var m = randi_range(2, 5)
	for n in range(m):
		var npc = quest_givers[randi_range(0, quest_givers.size() - 1)].instantiate()
		var pos: int = randi_range(0, possible_pos.size() - 1)
		
		for i in range(used_positions.size()):
			while pos == used_positions[i]:
				pos = randi_range(0, possible_pos.size() - 1)
		
		used_positions.append(pos)
		
		npc.position = possible_pos[pos]
		call_deferred("add_child", npc)
