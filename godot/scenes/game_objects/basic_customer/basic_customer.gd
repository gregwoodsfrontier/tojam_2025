extends CharacterBody2D

@onready var interactable: Interactable = $Interactable
@export var request_info: Request
@onready var thinking_timer: Timer = $ThinkingTimer
@onready var waiting_timer: Timer = $WaitingTimer

var id = 0
var food_wanted = Globals.FOOD_TYPE.GYUDON
var wait_time = 25.0
var tip = 3

var request_gen = { }

var dialog = [
	"Take my order!",
	"I SADI TAKE MT ORDER!!"
]
var tracker = 0

func _ready():
	id = Globals.id
	Globals.increment_id()
	thinking_timer.timeout.connect(_on_thinking_timer_timeout)
	# just an example below.
	interactable.interact = Callable(self, "_on_interact")
	interactable.action_name = dialog[tracker]

func _on_interact():
	tracker = min(tracker+1, 1)
	interactable.action_name = dialog[tracker]

func _on_thinking_timer_timeout():
	GameEvents.emit_ready_to_order(id)
