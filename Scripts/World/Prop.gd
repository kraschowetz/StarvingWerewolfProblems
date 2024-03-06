extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D

@export var player: CharacterBody2D

func _process(_delta) -> void:
	sprite.z_index = position.y
