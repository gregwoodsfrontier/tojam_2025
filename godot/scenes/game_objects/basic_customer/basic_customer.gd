extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var interactable: Interactable = $Interactable
@onready var thinking_timer: Timer = $ThinkingTimer
@onready var waiting_timer: Timer = $WaitingTimer
@onready var leave_timer: Timer = $LeaveTimer

@export var request_info: Request
@export var exit_target: Marker2D

const MAX_SPEED := 125.0
const ACCELERATION_SMOOTHING = 25.0

var nav_target: Node2D
var chair_target: Node2D
#var exit_target: Node2D

var id = 0
var food_wanted = Globals.FOOD_TYPE.GYUDON
var wait_time = 25.0
var tip = 3

var request_gen = { }

var dialog = [
	"Take my order!",
	"I SADI TAKE MT ORDER!!"
]
var tracker = 0

func _ready():
	id = Globals.id
	Globals.increment_id()
	
	GameEvents.tray_checked.connect(_on_tray_checked)
	thinking_timer.timeout.connect(_on_thinking_timer_timeout)
	waiting_timer.timeout.connect(_on_waiting_timer_timeout)
	leave_timer.timeout.connect(_on_leave_timer_timeout)
	if chair_target != null:
		nav_target = chair_target
	# just an example below.\
	#print(chair_target)
	interactable.interact = Callable(self, "_on_interact")
	interactable.action_name = dialog[tracker]
	if Globals.debug:
		chair_target = get_tree().get_first_node_in_group("chair")
		nav_target = chair_target

#func _process(delta: float) -> void:
	

func _physics_process(delta: float) -> void:
	var direction = _get_nav_direction()
	#if navigation_agent_2d.is_navigation_finished():
		#direction = Vector2.ZERO
	
	var target_velocity =  direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(- delta * ACCELERATION_SMOOTHING))
	if navigation_agent_2d.is_navigation_finished() && !leave_timer.is_stopped():
		leave_timer.stop()
	move_and_slide()

func set_chair_target(_chair: Node2D):
	chair_target = _chair
	
func get_chair_target() -> Node2D:
	return chair_target

func set_exit_target(_exit: Node2D):
	exit_target = _exit
	
func get_exit_target() -> Node2D:
	return exit_target

func _get_nav_direction() -> Vector2:
	var direction := Vector2.ZERO
	if nav_target == null:
		return Vector2.ZERO
	navigation_agent_2d.target_position = nav_target.global_position
	direction = navigation_agent_2d.get_next_path_position() - global_position
	direction = direction.normalized()
	return direction

func _on_interact():
	for_fun()
	GameEvents.emit_meal_served(food_wanted)

func _on_thinking_timer_timeout():
	GameEvents.emit_ready_to_order(id, food_wanted, tip)
	waiting_timer.start()

func _on_waiting_timer_timeout():
	# get angry
	nav_target = exit_target
	leave_timer.start()

func _on_leave_timer_timeout():
	print("customer %d is going to leave" % id)
	queue_free()

func _on_tray_checked(result: bool):
	if result == true:
		print(" happy ")
		#GameEvents.emit_tip_given(tip)
	else:
		modulate = Color(1,0,0,0.5)
	waiting_timer.stop()
	leave_timer.start()
	nav_target = exit_target

func for_fun():
	tracker = min(tracker+1, 1)
	interactable.action_name = dialog[tracker]
