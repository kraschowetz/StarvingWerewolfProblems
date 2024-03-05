extends Label

@onready var sub_label = $Label

var displayed_money: int
var tween: Tween

func _ready() -> void:
	Global.change_money.connect(on_money_changed)

func on_tween_fineshed() -> void:
	sub_label.text = ""

func on_money_changed() -> void:
	tween = get_tree().create_tween()
	tween.finished.connect(on_tween_fineshed)
	
	tween.tween_property(self, "displayed_money", Global.money, .75)
	
	var dif: int = abs(Global.money - displayed_money)
	var t: String = "+%s" % dif if Global.money > displayed_money else "-%s" % dif
	sub_label.text = t

func _process(_delta) -> void:
	if Global.money == text.to_int(): return
	
	if displayed_money < 10:
		text = "$0%s" % displayed_money
	else:
		text = "$%s" % displayed_money
