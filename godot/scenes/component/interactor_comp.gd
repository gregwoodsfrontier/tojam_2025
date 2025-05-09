extends Area2D
class_name InteractorComp

@export var interact_label: Label

var can_interact = true
var active_areas: Array[Interactable] = []

func _ready():
	GameEvents.interactor_area_entered.connect(_on_interactor_area_entered)
	GameEvents.interactor_area_exited.connect(_on_interactor_area_exited)

func _on_interactor_area_entered(other_area: Interactable):
	register_area(other_area)

func _on_interactor_area_exited(other_area: Interactable):
	unregister_area(other_area)


func register_area(other_area: Interactable):
	active_areas.push_back(other_area)

func unregister_area(other_area: Interactable):
	var area_to_remove_index := active_areas.find(other_area)
	if area_to_remove_index != -1:
		active_areas.remove_at(area_to_remove_index)

func _process(delata:float):
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(_sort_by_distance_with_owner)
		# something to show it is interactable now
		if interact_label == null:
			return
		else:
			interact_label.text = active_areas[0].action_name
			interact_label.global_position = (owner as Node2D).global_position
			interact_label.global_position.y -= 36
			interact_label.show()
	else:
		if interact_label == null:
			return
		else:	
			interact_label.hide()

func _sort_by_distance_with_owner(area1: Interactable, area2: Interactable):
	var distance_owner_to_area1 = (owner as Node2D).global_position.distance_to(area1.global_position)
	var distance_owner_to_area2 = (owner as Node2D).global_position.distance_to(area2.global_position)
	return distance_owner_to_area1 < distance_owner_to_area2

func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			await active_areas[0].interact.call()
			if interact_label == null:
				return
			else:
				interact_label.hide()
			can_interact = true
