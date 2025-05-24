extends Node2D
class_name DishSpace

var is_occupied := false:
	set(value):
		self.visible = value

var food_id := 0:
	set(value):
		animated_sprite_2d.set_frame(value)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var debug: Label = $Debug
@onready var interactable: Interactable = $Interactable

func _ready():
	interactable.interact = Callable(self, "_on_interact")
	interactable.area_exited.connect(_on_area_exited)
	is_occupied = false

func _on_interact():
	print("I am picked")

func _on_area_exited(area: Area2D):
	if area.get_parent() is Player:
		debug.visible = false
