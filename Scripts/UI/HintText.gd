extends Control

func display_text(_text: String) -> void:
	$Label.text = _text
	await get_tree().create_timer(2.5).timeout
	$Label.text = ""
