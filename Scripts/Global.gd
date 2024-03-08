extends Node

signal change_money

var money: int = 0
var hunger: int = 10
var debt: int = 50
var day: int = 1
var current_trans_data: Array[String] = ["", "", "", ""]
var last_trans_val: Array[int] = [100, 1]

var popularity: int = 0
var fear: int = 0

var spotted_lvl: int = 0

var in_minigame: bool = false

var player_position: Vector2 = Vector2.ZERO
