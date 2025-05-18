extends CharacterBody2D

@onready var customer_state_machine: Node = $CustomerStateMachine
@onready var interactable: Interactable = $Interactable
@onready var indicator_comp: Sprite2D = $IndicatorComp

@export var request_info: Request

const MAX_SPEED := 125.0
const ACCELERATION_SMOOTHING = 25.0

var id = 0
var food_wanted = Globals.FOOD_TYPE.PASTA: set = set_food_wanted
var wait_time = 20.0
var tip = 2

func _ready():
	interactable.interact = Callable(self, "_on_interact")


func set_food_wanted(_food: Globals.FOOD_TYPE):
	food_wanted = _food
	indicator_comp.set_food_id(_food)

func set_tip(_value: int):
	tip = _value

func set_exit_target(_exit: Node2D):
	if customer_state_machine == null:
		return
	customer_state_machine.set_exit_target(_exit)

func set_chair_target(_exit: Node2D):
	if customer_state_machine == null:
		return
	customer_state_machine.set_chair_target(_exit)

func _on_interact(_area: Area2D):
	if customer_state_machine.get_current_state() != "state_wait":
		return
	GameEvents.emit_meal_served(id, food_wanted)
	GameEvents.emit_tray_item_released()
