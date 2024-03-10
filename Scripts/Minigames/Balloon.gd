extends Button

func _on_pressed():
	get_parent().on_ballon_popped()
	queue_free()
