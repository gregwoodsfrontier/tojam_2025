extends Node
class_name FoodTrayManager

var player_held_food : Array[Globals.FOOD_TYPE]= []
const TRAY_LIMIT = 2

func _ready():
	GameEvents.meal_served.connect(_on_meal_served)

func get_food(_food: Globals.FOOD_TYPE):
	if player_held_food.size() >= TRAY_LIMIT:
		printerr("Cannot hold any more food la!")
		return
	player_held_food.push_back(_food)

func serve_food(_food: Globals.FOOD_TYPE):
	var index = player_held_food.find(_food)
	player_held_food.pop_at(index)

func _on_meal_served(_food_wanted: Globals.FOOD_TYPE):
	var result = check_if_tray_has_correct_food(_food_wanted)
	GameEvents.emit_tray_checked(result)

func check_if_tray_has_correct_food(_food_wanted: Globals.FOOD_TYPE) -> bool:
	var index = player_held_food.find(_food_wanted)
	if index < 0:
		return false
	player_held_food.pop_at(index)
	return true
