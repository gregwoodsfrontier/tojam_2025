extends Node

@onready var interactable: Interactable = $Interactable

var ready_meals = []

func _ready():
	interactable.interact = Callable(self, "_on_interact")
	GameEvents.request_complete.connect(_on_request_complete)

func _on_interact():
	print("collected meal from kitchen")
	GameEvents.emit_kitchen_interacted()
	print(ready_meals)

func _on_request_complete(finished_request):
	ready_meals.push_back(finished_request)
