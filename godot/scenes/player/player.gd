extends CharacterBody2D
class_name Player

@onready var indicator_comp: Sprite2D = $IndicatorComp

const MAX_SPEED := 125.0
const ACCELERATION_SMOOTHING = 25.0

func _ready() -> void:
	GameEvents.food_collected_by_tray.connect(_on_food_collected)
	GameEvents.tray_item_released.connect(_on_tray_item_released)

func _process(delta: float) -> void:
	var direction = get_movement_vec().normalized()
	var target_velocity =  direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(- delta * ACCELERATION_SMOOTHING))
	move_and_slide()

func get_movement_vec() -> Vector2:
	var x_move := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_move := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_move, y_move)

func _on_tray_item_released():
	if indicator_comp == null:
		printerr("Indicator comp in player not defined.")
		return
	indicator_comp.set_food_id(-1)
	print("food_id: ", indicator_comp.food_id)

func _on_food_collected(_foodId: Globals.FOOD_TYPE):
	if indicator_comp == null:
		printerr("Indicator comp in player not defined.")
		return
	indicator_comp.set_food_id(_foodId)
	print("collect food_id: ", indicator_comp.food_id)
