extends Node

var state_machine := CallableStateMachine.new()
var chair_target: Node2D
var exit_target: Node2D

@onready var navigation_agent_2d: NavigationAgent2D = $"../NavigationAgent2D"
@onready var velocity_component: VelocityComponent = $"../VelocityComponent"
@onready var thinking_timer: Timer = $"../ThinkingTimer"
@onready var waiting_timer: Timer = $"../WaitingTimer"
@onready var thinking_icon: Sprite2D = %ThinkingIcon

@export var basic_customer: CharacterBody2D

func _ready():
	GameEvents.tray_checked.connect(_on_tray_checked)
	thinking_timer.timeout.connect(_on_thinking_timeout)
	waiting_timer.timeout.connect(_on_waiting_timeout)
	state_machine.add_states(state_enter_shop, enter_state_enter_shop, Callable())
	state_machine.add_states(state_think, enter_state_think, exit_state_think)
	state_machine.add_states(state_wait, enter_state_wait, exit_state_wait)
	state_machine.add_states(state_leave, Callable(), Callable())
	state_machine.set_initial_state(state_enter_shop)

func _process(_delta):
	state_machine.update()

#region Update_States
func state_enter_shop():
	velocity_component.direction = _get_nav_direction(chair_target)
	if navigation_agent_2d.is_navigation_finished():
		state_machine.change_state(state_think)

func state_think():
	pass

func state_wait():
	pass

func state_leave():
	basic_customer.set_food_wanted(Globals.FOOD_TYPE.EMPTY)
	velocity_component.direction = _get_nav_direction(exit_target)
	if navigation_agent_2d.is_navigation_finished():
		basic_customer.call_deferred("queue_free")
	
#endregion

#region EnterStates
func enter_state_enter_shop():
	pass

func enter_state_think():
	thinking_timer.start()
	thinking_icon.visible = true

func enter_state_wait():
	waiting_timer.start()
#endregion

func exit_state_think():
	thinking_icon.visible = false

func exit_state_wait():
	waiting_timer.stop()

func set_exit_target(_target: Node2D):
	exit_target = _target

func set_chair_target(_target: Node2D):
	chair_target = _target

func get_current_state():
	return state_machine.current_state

func _get_nav_direction(_target: Node2D) -> Vector2:
	var direction := Vector2.ZERO
	var next_point := navigation_agent_2d.get_next_path_position()
	var distance_to_next := basic_customer.global_position.distance_to(next_point)
	if _target ==  null:
		return Vector2.ZERO
	navigation_agent_2d.target_position = _target.global_position
	if distance_to_next < navigation_agent_2d.target_desired_distance:
		return Vector2.ZERO
	direction = next_point - basic_customer.global_position
	direction = direction.normalized()
	return direction

func _on_thinking_timeout():
	basic_customer.set_food_wanted(randi_range(0, 2))
	GameEvents.emit_ready_to_order(basic_customer.id, basic_customer.food_wanted, basic_customer.tip)
	state_machine.change_state(state_wait)

func _on_waiting_timeout():
	state_machine.change_state(state_leave)

func _on_tray_checked(_id: int, result: bool):
	if basic_customer.id != _id:
		return
	if result == true:
		print("customer %d happy" % basic_customer.id)
		GameEvents.emit_tip_given(basic_customer.tip)
	else:
		basic_customer.modulate = Color(1,0,0,0.5)
	state_machine.change_state(state_leave)
	GameEvents.emit_customer_leaving(basic_customer.id)
