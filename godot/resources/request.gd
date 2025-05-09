extends Resource
class_name Request

#enum REQUEST_STAT {
	#QUEUE,
	#PROCESSING,
	#COMPLETE
#}

@export var customer: String
@export var food: String
@export var wait_time: float
@export var tip_value: int
#@export var status: REQUEST_STAT
