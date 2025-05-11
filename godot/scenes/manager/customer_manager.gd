extends Node

@onready var spawn_timer: Timer = $SpawnTimer
@onready var customer_group := get_tree().get_nodes_in_group("customer")
@onready var chair_groups := get_tree().get_nodes_in_group("chair")

@export var customer_scene : PackedScene
@export var spawn_point_group: Array[Marker2D]

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
	
	var spare_seats = chair_groups.filter(func(chair: Chair): return !chair.get_is_taken())
	if spare_seats.size() <= 0:
		return
	var rand_chair = spare_seats.pick_random()
	var chair_index = chair_groups.find(rand_chair)
	chair_groups[chair_index].set_is_taken(true)
	
	customer_instance.id = Globals.id
	Globals.increment_id()
	customer_instance.set_chair_target(rand_chair)
	customer_instance.set_exit_target(spawn_point_group.pick_random())
	customer_instance.set_food_wanted(randi_range(0, 2))
	customer_instance.set_tip(randi_range(TIP_RANGE[0], TIP_RANGE[1]))
	
	chair_customer_map[chair_index] = customer_instance.id
	
	add_child(customer_instance)
	
	spawn_timer.wait_time = SPAWN_TIME_AFTER_FIRST

func _on_spawn_timer_timeout():
	if spawn_point_group.size() == 0:
		return
	var spawn_point = spawn_point_group.pick_random() as Marker2D
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
