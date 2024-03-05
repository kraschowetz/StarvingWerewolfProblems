extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D

@export var player: CharacterBody2D

func _process(_delta) -> void:
	if player.position.y > position.y:
		sprite.z_index = -1
	else:
		sprite.z_index = 1
