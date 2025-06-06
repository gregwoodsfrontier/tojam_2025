extends Node

var dish_space_pool : Array[Node] = []

@export var food_tray_manager: FoodTrayManager

@onready var process_timer: Timer = $ProcessTimer

var request_pool = []

func _ready():
	request_pool = [
		{
			"dish" = Globals.FOOD_TYPE.RICE,
			"is_ready" = false,
			"cook_time" = 3.0
		},
		{
			"dish" = Globals.FOOD_TYPE.PASTA,
			"is_ready" = false,
			"cook_time" = 4.0
		},
		{
			"dish" = Globals.FOOD_TYPE.PIZZA,
			"is_ready" = false,
			"cook_time" = 5.0
		}
	]
	
	process_timer.timeout.connect(_on_process_timer_timeout)
	dish_space_pool = get_tree().get_nodes_in_group("dish_space")

func _make_kitchen_process_order():
	var ready_request_pool = request_pool.filter(func(e): return e["is_ready"] == false)
	if ready_request_pool.is_empty():
		return
	var first_request = ready_request_pool[0]
	first_request.is_ready = true
	
	var empty_space_pool = dish_space_pool.filter(func(e): return e.visible == false)
	if empty_space_pool.is_empty():
		return
	print(empty_space_pool[0].food_id)
	(empty_space_pool[0] as DishSpace).set_food_id(first_request["dish"])
	print(empty_space_pool[0].food_id)
	print("test")

func check_process_availability():
	var ready_request_pool = request_pool.filter(func(e): return e["is_ready"] == false)
	var empty_space_pool = dish_space_pool.filter(func(e): return e.visible == false)
	var no_request = ready_request_pool.is_empty()
	var no_space = empty_space_pool.is_empty()
	return !no_request and process_timer.is_stopped() and !no_space

func _process(delta: float):
	if check_process_availability():
		process_timer.start()

func _on_process_timer_timeout():
	_make_kitchen_process_order()

func _on_kitchen_interacted():
	# it should grab a dish from the table
	pass
