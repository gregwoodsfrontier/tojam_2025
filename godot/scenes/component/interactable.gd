extends Area2D
class_name Interactable

# helper var

@export var action_name: String

var interact: Callable = func():
	pass

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(other_area: Area2D):
	GameEvents.interactor_area_entered.emit(self)

func _on_area_exited(other_area: Area2D):
	GameEvents.interactor_area_exited.emit(self)
