extends CharacterBody2D

@onready var player = get_node("../Player")
@onready var world = get_node("../")
@onready var ray = $RayCast2D
@onready var nav_timer = $Timer
@onready var agent = $NavigationAgent2D

@export var base_fame_increase: int = 1
@export var base_infamy_increase: int = 1
@export var detection_range: int
@export var _skull: Texture2D

@export var light_pivot: Node2D
@export var ref_pivot: Node2D

var world_target: int 
var exit_pos: int = -1
var paths_ammount: int

var scared: bool = false
var speed = 90
var player_in_line_of_sight: bool = false

"""
	X: 15-1953
	y: 18-1704
"""

func check_for_player() -> void:
	if scared: return
	
	if position.distance_to(player.position) < 100:
		scared = true
		agent.target_position = world.civilian_start_pos[randi_range(0, world.civilian_start_pos.size() -1)]
		speed = speed * 2.5
		Global.popularity += base_fame_increase
		Global.fear += base_infamy_increase
		Global.spotted_lvl = 2
		return
	
	ray.target_position = player.position - position
	if !player_in_line_of_sight: return
	if !ray.get_collider(): return
	if ray.get_collider().name == "Player" && !scared:
		scared = true
		agent.target_position = world.civilian_start_pos[randi_range(0, world.civilian_start_pos.size() -1)]
		speed = speed * 2.5
		Global.popularity += base_fame_increase
		Global.fear += base_infamy_increase
		Global.spotted_lvl = 2

func _ready() -> void:
	world_target = randi_range(0, world.civilian_target_pos.size() -1)
	paths_ammount = 99

func _process(delta) -> void:
	var dir = to_local(agent.get_next_path_position()).normalized()
	velocity = dir * speed
	
	$Sprite2D.z_index = position.y
	
	check_for_player()
	
	if scared || exit_pos > -1:
		if position.x < 20 || position.x > 1950:
			if scared:
				Global.fear += base_infamy_increase * 2
				Global.popularity += base_fame_increase
			queue_free()
		if position.y < 22 || position.y > 1700:
			if scared:
				Global.fear += base_infamy_increase * 2
				Global.popularity += base_fame_increase
			queue_free()
	
	if light_pivot:
		ref_pivot.look_at(agent.get_next_path_position())
		light_pivot.rotation = lerp(light_pivot.rotation, ref_pivot.rotation, delta)
	
	if position.distance_to(agent.target_position) < 48:
		world_target = randi_range(0, world.civilian_target_pos.size() -1)
		return
	
	move_and_slide()

func _on_timer_timeout():
	if scared: return
	
	if position.distance_to(agent.target_position) < 48:
		paths_ammount -= 1
	
	if paths_ammount <= 0:
		if exit_pos >= 0: return
		exit_pos = randi_range(0, world.civilian_start_pos.size() -1)
		agent.target_position = world.civilian_start_pos[exit_pos]
		return
	
	agent.target_position = world.civilian_target_pos[world_target]

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		speed = 0
		Global.hunger -= 2
		$Sprite2D.texture = _skull


func _on_visibility_area_body_entered(body):
	if body.name == "Player":
		player_in_line_of_sight = true

func _on_visibility_area_body_exited(body):
	if body.name == "Player":
		player_in_line_of_sight = false
