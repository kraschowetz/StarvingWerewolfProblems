extends StaticBody2D

func _on_area_2d_body_entered(body):
	if Global.money < 1: return
	if body.name != "Player": return
	
	Global.debt -= Global.money
	if Global.debt < 1:
		Global.debt = 1
	
	Global.money = 0
	Global.change_money.emit()
