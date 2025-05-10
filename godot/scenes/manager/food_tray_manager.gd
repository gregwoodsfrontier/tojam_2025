extends Node

var player_held_food : Array[Globals.FOOD_TYPE]= []
const TRAY_LIMIT = 2

func get_food(_food: Globals.FOOD_TYPE):
	if player_held_food.size() >= TRAY_LIMIT:
		printerr("Cannot hold any more food la!")
		return
	player_held_food.push_back(_food)

func serve_food(_food: Globals.FOOD_TYPE):
	var index = player_held_food.find(_food)
	player_held_food.pop_at(index)
