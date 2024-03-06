extends CharacterBody2D

@onready var player = get_node("../Player")
@onready var world = get_node("../")
@onready var nav_timer = $Timer
@onready var agent = $NavigationAgent2D

var world_target: int 

func _ready() -> void:
	world_target = randi_range(0, world.civilian_target_pos.size() -1)

func _process(_delta) -> void:
	var dir = to_local(agent.get_next_path_position()).normalized()
	velocity = dir * 90
	
	$Sprite2D.z_index = position.y
	
	if position.distance_to(agent.target_position) < 48:
		world_target = randi_range(0, world.civilian_target_pos.size() -1)
		return
	
	move_and_slide()

func _on_timer_timeout():
	agent.target_position = world.civilian_target_pos[world_target]
