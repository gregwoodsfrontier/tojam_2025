extends Node

enum FOOD_TYPE {
	BURGER, GYUDON, SALAD
}

enum REQUEST_STAT {
	QUEUE,
	PROCESSING,
	COMPLETE
}

const request_type = {
	"customer_id": 0,
	"food": FOOD_TYPE,
	"wait_time": 0,
	"tip_value": 0,
	"status": REQUEST_STAT
}

var request_pool = []
var current_customer_id = 0

func add_request():
	var req = request_type.duplicate()
	req["customer_id"] = current_customer_id
	current_customer_id += 1
	req["food"] = randi_range(FOOD_TYPE.BURGER, FOOD_TYPE.SALAD)
	req["wait_time"] = randf_range(20.0, 30.0)
	req["tip_value"] = randi_range(1,3)
	req["status"] = REQUEST_STAT.QUEUE
	
	request_pool.push_back(req)
