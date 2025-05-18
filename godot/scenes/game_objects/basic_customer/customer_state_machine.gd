extends Node

var state_machine := CallableStateMachine.new()
var chair_target: Node2D

@onready var navigation_agent_2d: NavigationAgent2D = $"../NavigationAgent2D"
@onready var velocity_component: VelocityComponent = $"../VelocityComponent"
@onready var thinking_timer: Timer = $"../ThinkingTimer"

@export var basic_customer: CharacterBody2D

func _ready():
	GameEvents.seat_assigned.connect(_on_seat_assigned)
	thinking_timer.timeout.connect(_on_thinking_timeout)
	state_machine.add_states(state_enter_shop, enter_state_enter_shop, Callable())
	state_machine.add_states(state_think, enter_state_think, Callable())
	state_machine.add_states(state_wait, Callable(), Callable())
	state_machine.add_states(state_leave, Callable(), Callable())
	state_machine.set_initial_state(state_enter_shop)

func _process(_delta):
	state_machine.update()

#region States
func state_enter_shop():
	velocity_component.direction = _get_nav_direction()
	if navigation_agent_2d.is_navigation_finished():
		state_machine.change_state(state_think)

func state_think():
	pass

func state_wait():
	pass

func state_leave():
	pass

#endregion

#region EnterStates
func enter_state_enter_shop():
	pass

func enter_state_think():
	thinking_timer.start()
#endregion

func _get_nav_direction() -> Vector2:
	var direction := Vector2.ZERO
	var next_point := navigation_agent_2d.get_next_path_position()
	var distance_to_next := basic_customer.global_position.distance_to(next_point)
	if chair_target ==  null:
		return Vector2.ZERO
	navigation_agent_2d.target_position = chair_target.global_position
	if distance_to_next < navigation_agent_2d.target_desired_distance:
		return Vector2.ZERO
	direction = next_point - basic_customer.global_position
	direction = direction.normalized()
	return direction

func _on_seat_assigned(_id: int, _chair: Chair):
	if _id != basic_customer.id:
		return
	chair_target = _chair
	print("chair_assigned")

func _on_thinking_timeout():
	basic_customer.set_food_wanted(randi_range(0, 2))
	state_machine.change_state(state_wait)
