extends Node2D
class_name DishSpace

@export var food_id : int = Globals.FOOD_TYPE.EMPTY

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var debug: Label = $Debug
@onready var interactable: Interactable = $Interactable

func _ready():
	interactable.interact = Callable(self, "_on_interact")
	interactable.area_exited.connect(_on_area_exited)

func set_food_id(value):
	food_id = value
	if value == -1:
		self.visible = false
		return
	self.visible = true
	animated_sprite_2d.set_frame(value)

func get_occupied_state():
	return self.visible


func _on_interact(_area: Area2D):
	if food_id == Globals.FOOD_TYPE.EMPTY:
		return
	var parent_node = _area.get_parent()
	if  parent_node is Player:
		if (parent_node as Player).is_foodtray_empty():
			GameEvents.emit_dish_collected(food_id)
			set_food_id(Globals.FOOD_TYPE.EMPTY)
		else:
			print("food tray is full")


func _on_area_exited(area: Area2D):
	if area.get_parent() is Player:
		debug.visible = false
