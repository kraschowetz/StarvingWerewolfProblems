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
var dead: bool = false
var speed = 90

func _ready() -> void:
	world_target = randi_range(0, world.civilian_target_pos.size() -1)
	paths_ammount = randi_range(2, 8)

func _process(delta) -> void:
	var dir = to_local(agent.get_next_path_position()).normalized()
	velocity = dir * speed
	
	$Sprite2D.z_index = position.y
	
	ray.target_position = player.position - position
	if (ray.get_collision_point() - position).length() < detection_range:
		if !ray.get_collider(): return
		if ray.get_collider().name == "Player" && !scared:
			scared = true
			agent.target_position = world.civilian_start_pos[randi_range(0, world.civilian_start_pos.size() -1)]
			speed = speed * 2.5
			Global.popularity += base_fame_increase
			Global.fear += base_infamy_increase
	
	if scared || exit_pos > -1:
		if position.x < 20 || position.x > 1950:
			if scared:
				Global.fear += base_infamy_increase * 2
				Global.popularity += base_fame_increase
				if Global.spotted_lvl < 1:
					Global.spotted_lvl = 1
			queue_free()
		if position.y < 22 || position.y > 1700:
			if scared:
				Global.fear += base_infamy_increase * 2
				Global.popularity += base_fame_increase
				if Global.spotted_lvl < 1:
					Global.spotted_lvl = 1
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
		Global.hunger -= 4
		$Sprite2D.texture = _skull
		dead = true
