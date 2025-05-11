extends Node

@export var food_tray_manager: FoodTrayManager

@onready var process_timer: Timer = $ProcessTimer

const READY_MEAL_SIZE_lIMIT = 3

var request_pool = []
var ready_meals = []
var process_time = 3.0

func _ready():
	GameEvents.ready_to_order.connect(_on_ready_to_order)
	GameEvents.kitchen_interacted.connect(_on_kitchen_interacted)
	process_timer.timeout.connect(_on_process_timer_timeout)

func _on_ready_to_order(id: int, food_type: Globals.FOOD_TYPE, tip: int):
	add_request(id, food_type, tip)

func add_request(id: int, food_type: Globals.FOOD_TYPE, tip: int):
	var request = {
		"customer_id" = id,
		"food" = food_type,
		"tip" = tip,
		"status" = Globals.REQUEST_STAT.QUEUE
	}
	request_pool.push_back(request)

func do_the_request():
	if request_pool.size() > 0 && process_timer.is_stopped():
		var now_process_request = request_pool.filter(func(e): return e["status"] == Globals.REQUEST_STAT.QUEUE)
		if now_process_request.size() <= 0:
			return
		now_process_request[0]["status"] = Globals.REQUEST_STAT.PROCESSING
		process_timer.wait_time = process_time
		process_timer.start()
		

func _process(delta: float):
	do_the_request()

func _on_process_timer_timeout():
	#this might introduce bugs later
	var processing_req = request_pool.filter(func(e): return e["status"] == Globals.REQUEST_STAT.PROCESSING)
	if processing_req.size() <= 0:
		return
	processing_req[0]["status"] = Globals.REQUEST_STAT.SERVE_READY
	# this code will send events to kitchen.
	#GameEvents.emit_request_complete(finished_request)
	if ready_meals.size() >= READY_MEAL_SIZE_lIMIT:
		print("ready meal size is at limit.")
		return
		
	var finished_request = processing_req.pop_front()
	ready_meals.push_back(finished_request)
	print("request_complete fire.")
	#complete_request_pool.push_back(finished_request)

func _on_kitchen_interacted():
	if ready_meals.size() <= 0:
		print("No meals ready for pickup.")
		return
	var ready_request = ready_meals.pop_front()
	var ready_food = ready_request["food"]
	food_tray_manager.get_food(ready_food)
