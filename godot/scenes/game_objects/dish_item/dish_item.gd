extends Node2D
class_name DishItem

var food_id := 0:
	set(value):
		animated_sprite_2d.set_frame(value)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var debug: Label = $Debug
@onready var interactable: Interactable = $Interactable

func _ready():
	interactable.interact = Callable(self, "_on_interact")
	interactable.area_exited.connect(_on_area_exited)

func _on_interact():
	print("I am picked")

func _on_area_exited(area: Area2D):
	if area.get_parent() is Player:
		debug.visible = false
