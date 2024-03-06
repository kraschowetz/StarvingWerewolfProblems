extends Node

signal change_money

var money: int = 0
var hunger: int = 10
var debt: int = 50
var day: int = 1
var current_trans_data: Array[String] = ["", "", "", ""]
var last_trans_val: Array[int] = [1, 1]

var in_minigame: bool = false

var player_position: Vector2 = Vector2.ZERO
