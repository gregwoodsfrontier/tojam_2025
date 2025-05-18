extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var interactable: Interactable = $Interactable
@onready var thinking_timer: Timer = $ThinkingTimer
@onready var waiting_timer: Timer = $WaitingTimer
@onready var leave_timer: Timer = $LeaveTimer
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var indicator_comp: Sprite2D = $IndicatorComp

@export var request_info: Request
@export var exit_target: Marker2D

const MAX_SPEED := 125.0
const ACCELERATION_SMOOTHING = 25.0

var nav_target: Node2D
#var exit_target: Node2D

var id = 0
var food_wanted = Globals.FOOD_TYPE.PASTA: set = set_food_wanted
var wait_time = 20.0
var tip = 2

var dialog = [
	"Take my order!",
	"I SADI TAKE MT ORDER!!"
]
var tracker = 0

func _ready():
	GameEvents.tray_checked.connect(_on_tray_checked)
	thinking_timer.timeout.connect(_on_thinking_timer_timeout)
	waiting_timer.timeout.connect(_on_waiting_timer_timeout)
	leave_timer.timeout.connect(_on_leave_timer_timeout)
	interactable.interact = Callable(self, "_on_interact")
	interactable.action_name = dialog[tracker]

func _process(delta: float) -> void:
	#velocity_component.direction = _get_nav_direction()
	if navigation_agent_2d.is_navigation_finished() && !leave_timer.is_stopped():
		leave_timer.stop()
		queue_free()

func set_food_wanted(_food: Globals.FOOD_TYPE):
	food_wanted = _food
	indicator_comp.set_food_id(_food)

func set_tip(_value: int):
	tip = _value

func set_exit_target(_exit: Node2D):
	exit_target = _exit
	
func get_exit_target() -> Node2D:
	return exit_target

#func _get_nav_direction() -> Vector2:
	#var direction := Vector2.ZERO
	#var next_point := navigation_agent_2d.get_next_path_position()
	#var distance_to_next := global_position.distance_to(next_point)
	##navigation_agent_2d.target_position = nav_target.global_position
	#if distance_to_next < navigation_agent_2d.target_desired_distance:
		#return Vector2.ZERO
	#direction = next_point - global_position
	#direction = direction.normalized()
	#return direction

func _on_interact():
	for_fun()
	GameEvents.emit_meal_served(id, food_wanted)
	GameEvents.emit_tray_item_released()

func _on_thinking_timer_timeout():
	GameEvents.emit_ready_to_order(id, food_wanted, tip)
	waiting_timer.start()

func _on_waiting_timer_timeout():
	modulate = Color(1,0,0,0.5)
	nav_target = exit_target
	leave_timer.start()
	GameEvents.emit_customer_leaving(id)

func _on_leave_timer_timeout():
	print("customer %d is going to leave" % id)
	queue_free()

func _on_tray_checked(_id: int, result: bool):
	if id != _id:
		return
	if result == true:
		print("customer %d happy" % id)
		GameEvents.emit_tip_given(tip)
	else:
		modulate = Color(1,0,0,0.5)
	waiting_timer.stop()
	leave_timer.start()
	GameEvents.emit_customer_leaving(id)
	nav_target = exit_target

func for_fun():
	tracker = min(tracker+1, 1)
	interactable.action_name = dialog[tracker]
