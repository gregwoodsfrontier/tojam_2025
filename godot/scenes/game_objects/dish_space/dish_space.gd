extends Node2D
class_name DishSpace

var test = 0.0

@export var food_id := Globals.FOOD_TYPE.EMPTY

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
	print("I am picked")

func _on_area_exited(area: Area2D):
	if area.get_parent() is Player:
		debug.visible = false
