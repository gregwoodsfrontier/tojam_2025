extends Node

var id = 0
var debug = true

enum FOOD_TYPE {
	BURGER, GYUDON, SALAD
}

enum REQUEST_STAT {
	QUEUE,
	PROCESSING,
	SERVE_READY,
	COMPLETE
}

func increment_id():
	id += 1
