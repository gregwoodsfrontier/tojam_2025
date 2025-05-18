extends Sprite2D

@export var food_carried: Sprite2D

var food_id: Globals.FOOD_TYPE = -1

func _process(delta):
	if food_id == Globals.FOOD_TYPE.EMPTY:
		self.visible = false
		food_carried.visible = false
	else:
		self.visible = true
		food_carried.visible = true

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
