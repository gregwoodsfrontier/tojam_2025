extends Node

var state_machine := CallableStateMachine.new()
var chair_target: Node2D

@export var basic_customer: CharacterBody2D

func _ready():
	GameEvents.seat_assigned.connect(_on_seat_assigned)
	state_machine.add_states(state_enter_shop, Callable(), Callable())
	state_machine.add_states(state_think, Callable(), Callable())
	state_machine.add_states(state_wait, Callable(), Callable())
	state_machine.add_states(state_leave, Callable(), Callable())
	state_machine.set_initial_state(state_enter_shop)

func _process(_delta):
	state_machine.update()

#region States
func state_enter_shop():
	pass

func state_think():
	pass

func state_wait():
	pass

func state_leave():
	pass

#endregion

func _on_seat_assigned(_id: int, _chair: Chair):
	if _id != basic_customer.id:
		return
	chair_target = _chair
	print("chair_assigned")
