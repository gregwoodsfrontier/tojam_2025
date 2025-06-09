extends Node2D

@onready var interactable: Interactable = $Interactable

func _ready():
	interactable.interact = Callable(self, "_on_interact")


func _on_interact(_area: Area2D):
	var parent_node = _area.get_parent()
	if parent_node ==  null:
		return
	if parent_node is not Player:
		return
	var player_node = parent_node as Player
	var player_food_tray = player_node.food_tray_component as FoodTrayComp
	if player_food_tray.get_collected_dish() == Globals.FOOD_TYPE.EMPTY:
		return
	player_food_tray.dispose_dish()
	print("dish are disposed")
	GameEvents.emit_dish_disposed()
	# can emit food_disposed on GameEvents
