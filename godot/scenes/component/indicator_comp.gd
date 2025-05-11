extends Sprite2D

@export var food_carried: Sprite2D

var food_id: Globals.FOOD_TYPE

func _ready():
	GameEvents.food_collected_by_tray.connect(_on_food_collected)
	GameEvents.tray_item_released.connect(_on_tray_item_released)

func _on_tray_item_released():
	set_food_id(-1)
	print("food_id: ", food_id)

func _on_food_collected(_foodId: Globals.FOOD_TYPE):
	set_food_id(_foodId)
	print("collect food_id: ", food_id)

func set_food_id(_id: Globals.FOOD_TYPE):
	food_id = _id
	change_sprite_of_food(_id)

func get_food_id():
	return food_id

func change_sprite_of_food(_food_id: Globals.FOOD_TYPE):
	if _food_id == -1:
		food_carried.texture = null
		return
	food_carried.texture = Globals.food_texture[_food_id]
