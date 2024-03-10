extends Control

@export var balloon: PackedScene
@export var sprite: Sprite2D
@export var imgs: Array[Texture2D]

var ammount: int

func on_ballon_popped() -> void:
	ammount -= 1
	if ammount <= 0:
		sprite.self_modulate = Color(1, 1, 1, 1)
		await get_tree().create_timer(1.2).timeout
		Global.money += randi_range(6, 12)
		Global.change_money.emit()
		Global.in_minigame = false
		queue_free()

func _ready() -> void:
	var a = randi_range(8, 20)
	ammount = a
	sprite.self_modulate = Color(0, 0, 0, 1)
	
	var s = randi_range(0, imgs.size())
	if s < imgs.size():
		sprite.texture = imgs[s]
	
	for i in range(a):
		var b = balloon.instantiate()
		b.position = sprite.position + Vector2(randi_range(-96, 96) - 36, randi_range(-96, 96) -36)
		add_child(b)
