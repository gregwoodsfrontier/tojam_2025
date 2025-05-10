extends Node
@onready var process_timer: Timer = $ProcessTimer

#const request_type = {
	#"customer_id": 0,
	#"food": GFOOD_TYPE,
	#"wait_time": 0,
	#"tip_value": 0,
	#"status": REQUEST_STAT
#}

var request_pool = []
var process_time = 3.0

func _ready():
	GameEvents.ready_to_order.connect(_on_ready_to_order)

func _on_ready_to_order(customer_id: int):
	add_request(customer_id)

func add_request(customer_id: int):
	var request = {
		"customer_id" = customer_id,
		"food" = Globals.FOOD_TYPE.BURGER,
		"wait_time" = randf_range(20.0, 30.0),
		"tip" = randi_range(1, 3)
	}
	request_pool.push_back(request)

func do_the_request():
	if request_pool.size() > 0 && process_timer.is_stopped():
		process_timer.wait_time = process_time
		process_timer.start()

func _process(delta: float):
	do_the_request()
