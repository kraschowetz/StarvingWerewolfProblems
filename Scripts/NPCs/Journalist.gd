extends CharacterBody2D

@onready var player = get_node("../Player")
@onready var world = get_node("../")
@onready var hint_label = get_node("../CanvasLayer/HintText")
@onready var ray = $RayCast2D
@onready var nav_timer = $Timer
@onready var agent = $NavigationAgent2D
@onready var photo_timer = $PhotoTimer
@onready var light = $Pivot/PointLight2D

@export var base_fame_increase: int = 1
@export var base_infamy_increase: int = 1
@export var detection_range: int
@export var _skull: Texture2D

@export var light_pivot: Node2D
@export var ref_pivot: Node2D

var world_target: int 
var exit_pos: int = -1
var paths_ammount: int

var speed = 90
var player_in_line_of_sight: bool = false

var state: String = "wandering"
var dead: bool = false

func check_for_player() -> void:
	if state != "wandering": return
	
	if position.distance_to(player.position) < 100:
		state = "shooting"
		shoot(player.position, "you was photografed", 2)
		agent.target_position = world.civilian_start_pos[randi_range(0, world.civilian_start_pos.size() -1)]
		speed = speed * 2.5
		Global.popularity += base_fame_increase
		Global.fear += base_infamy_increase
		return
	
	ray.target_position = player.position - position
	if !player_in_line_of_sight: return
	if !ray.get_collider(): return
	if ray.get_collider().name == "Player" && state == "wandering":
		state = "shooting"
		shoot(player.position, "you was photografed", 2)
		agent.target_position = world.civilian_start_pos[randi_range(0, world.civilian_start_pos.size() -1)]
		speed = speed * 2.5
		Global.popularity += base_fame_increase
		Global.fear += base_infamy_increase

func _ready() -> void:
	world_target = randi_range(0, world.civilian_target_pos.size() -1)
	paths_ammount = 99

func _process(delta) -> void:
	var dir = to_local(agent.get_next_path_position()).normalized()
	velocity = dir * speed
	
	$Sprite2D.z_index = position.y
	
	check_for_player()
	
	if state == "scared" || exit_pos > -1:
		if position.x < 20 || position.x > 1950:
			if state == "scared":
				Global.fear += base_infamy_increase * 2
				Global.popularity += base_fame_increase
			queue_free()
		if position.y < 22 || position.y > 1700:
			if state == "scared":
				Global.fear += base_infamy_increase * 2
				Global.popularity += base_fame_increase
			queue_free()
	
	
	if light_pivot && state != "shooting":
		ref_pivot.look_at(agent.get_next_path_position())
		light_pivot.rotation = lerp(light_pivot.rotation, ref_pivot.rotation, delta)
	
	if position.distance_to(agent.target_position) < 48:
		world_target = randi_range(0, world.civilian_target_pos.size() -1)
		return
	
	if state != "shooting":
		move_and_slide()

func shoot(_pos: Vector2, _txt: String, _p: int) -> void:
	light_pivot.look_at(_pos)
	light.color = Color("ffffff")
	photo_timer.start()
	Global.spotted_lvl = _p
	hint_label.display_text(_txt)
	await get_tree().create_timer(.5).timeout
	light.color = Color("777777")

func _on_timer_timeout():
	if exit_pos < 0 && state == "scared": return
	
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
		light.visible = false
		dead = true


func _on_visibility_area_body_entered(body):
	if body.name == "Player":
		player_in_line_of_sight = true
	

func _on_visibility_area_body_exited(body):
	if body.name == "Player":
		player_in_line_of_sight = false

func _on_photo_timer_timeout():
	state = "scared"

func _on_visibility_area_area_entered(area):
	if area.get_parent().get_class() == "CharacterBody2D" && area.get_parent().dead:
		state = "shooting"
		print("elias jabur")
		speed = speed * 2.5
		agent.target_position = world.civilian_start_pos[randi_range(0, world.civilian_start_pos.size() -1)]
		Global.popularity += base_fame_increase
		Global.fear += 1
		shoot(area.global_position, "a journalist saw a dead body", 1)
