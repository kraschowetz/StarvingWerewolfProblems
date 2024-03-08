extends Node2D

@onready var header = $Head
@onready var comunity_poll = $ComunityPoll

@export var spotted_lvl_0_headers: Array[String]
@export var spotted_lvl_1_headers: Array[String]
@export var spotted_lvl_2_headers: Array[String]

func _input(event) -> void:
	if event is InputEventMouseMotion: return
	Global.spotted_lvl = 0
	get_tree().call_deferred("change_scene_to_file", Global.current_trans_data[2])

func gen_header() -> String:
	match Global.spotted_lvl:
		0:
			return spotted_lvl_0_headers[randi_range(0, spotted_lvl_0_headers.size() - 1)]
		1:
			return spotted_lvl_1_headers[randi_range(0, spotted_lvl_1_headers.size() - 1)]
		2:
			return spotted_lvl_2_headers[randi_range(0, spotted_lvl_2_headers.size() - 1)]
	return " HOW DID WE GET HERE?"

func gen_poll_text() -> String:
	var intensity: int = Global.popularity + Global.fear
	
	if intensity < 10:
		return " The werewolf myth gains popularity among 3 very specific people"
	elif intensity < 45:
		return " Is it really a werewolf or just a really hairy guy?"
	elif intensity < 60:
		return " Townsfolk have mixed opinions on the werewolf legend"
	elif intensity < 90:
		return "who don't believe in werewolves nowdays"
	else:
		return "werewolf menace needs to be stopped"

func _ready() -> void:
	header.text = gen_header()
	
	comunity_poll.text = "\n FAME: %s" % Global.popularity + "%" + "\n INFAME %s" % Global.fear + "%\n\n" + gen_poll_text()
