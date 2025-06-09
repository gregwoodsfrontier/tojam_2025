extends Node
class_name FoodTrayComp

var collect_dish_id : Globals.FOOD_TYPE = Globals.FOOD_TYPE.EMPTY

func _ready():
	GameEvents.dish_collected.connect(_on_dish_collected)


func get_collected_dish() -> Globals.FOOD_TYPE:
	return collect_dish_id


func dispose_dish():
	collect_dish_id = Globals.FOOD_TYPE.EMPTY

func _on_dish_collected(food_id: int):
	if food_id != Globals.FOOD_TYPE.EMPTY:
		collect_dish_id = food_id
		print("dish collected: %s" % food_id)
