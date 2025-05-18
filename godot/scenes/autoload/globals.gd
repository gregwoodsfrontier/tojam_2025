extends Node

var id = 0
var debug = true

const food_sprite_paths = [
	"res://sprites/food_items/pasta.png",
	"res://sprites/food_items/pizza.png",
	"res://sprites/food_items/rice.png"
]

var food_texture = []

enum FOOD_TYPE {
	PASTA, PIZZA, RICE, EMPTY = -1
}

enum REQUEST_STAT {
	QUEUE,
	PROCESSING,
	SERVE_READY,
	COMPLETE
}

func _ready():
	for path in food_sprite_paths:
		var tex = load(path)
		food_texture.push_back(tex)

func increment_id():
	id += 1
