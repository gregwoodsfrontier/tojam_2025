extends Node

@onready var spawn_timer: Timer = $SpawnTimer
@onready var customer_group := get_tree().get_nodes_in_group("customer")
@onready var chair_groups := get_tree().get_nodes_in_group("seat")

@export var customer_scene : PackedScene
@export var spawn_point: Marker2D

const TIP_RANGE = [2, 5]
const SPAWN_TIME_AFTER_FIRST = 3

var chair_customer_map = {} # chair_idx = customer_id

func _ready():
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	GameEvents.customer_leaving.connect(_on_customer_leaving)

func spawn_customer(px: float, py: float):
	if customer_scene == null:
		return
	var customer_instance = customer_scene.instantiate() as Node2D
	customer_instance.global_position.x = px
	customer_instance.global_position.y = py
	customer_instance.id = Globals.id
	Globals.increment_id()
	add_child(customer_instance)
	#var rand_chair = assign_chair(customer_instance)
	assign_chair(customer_instance)
	customer_instance.set_exit_target(spawn_point)
	customer_instance.set_tip(randi_range(TIP_RANGE[0], TIP_RANGE[1]))
	#GameEvents.emit_seat_assigned(customer_instance.id, rand_chair)
	spawn_timer.wait_time = SPAWN_TIME_AFTER_FIRST

func assign_chair(_customer_instance: Node2D):
	var spare_seats = chair_groups.filter(func(seat: SeatMarker): return !seat.is_occupied)
	if spare_seats.size() <= 0:
		print("No more chairs left.")
		return
	var rand_chair = spare_seats.pick_random()
	_customer_instance.set_chair_target(rand_chair)
	#var chair_index = chair_groups.find(rand_chair)
	var chair_index = 0
	#chair_groups[chair_index].set_is_taken(true)
	chair_groups[chair_index].is_occupied = true
	chair_customer_map[chair_index] = _customer_instance.id
	return rand_chair

func _on_spawn_timer_timeout():
	var spare_seats = chair_groups.filter(func(chair: Chair): return !chair.get_is_taken())
	if spawn_point == null:
		return
	spawn_customer(spawn_point.global_position.x, spawn_point.global_position.y)

func _on_customer_leaving(target_id: int):
	for chairIndex in chair_customer_map:
		var finding_id = chair_customer_map[chairIndex]
		if finding_id == target_id:
			chair_customer_map[chairIndex] = null
			if chair_groups[chairIndex] == null:
				break
				return
			chair_groups[chairIndex].set_is_taken(false)
			break
