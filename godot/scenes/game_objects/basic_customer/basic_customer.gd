extends CharacterBody2D

@onready var interactable: Interactable = $Interactable
@export var request_info: Request

var dialog = [
	"Take my order!",
	"I SADI TAKE MT ORDER!!"
]
var tracker = 0

func _ready():
	interactable.interact = Callable(self, "_on_interact")
	interactable.action_name = dialog[tracker]

func _on_interact():
	tracker = min(tracker+1, 1)
	interactable.action_name = dialog[tracker]
