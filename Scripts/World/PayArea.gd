extends StaticBody2D

@export var hint_text: Control

func _on_area_2d_body_entered(body):
	if Global.money < 1: return
	if body.name != "Player": return
	
	Global.debt -= Global.money
	if Global.debt < 1:
		Global.debt = 1
	
	hint_text.display_text("you paid off your debts")
	
	Global.money = 0
	Global.change_money.emit()
