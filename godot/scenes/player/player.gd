extends CharacterBody2D
class_name Player

@onready var indicator_comp: Sprite2D = $IndicatorComp
@onready var food_tray_component: FoodTrayComp = $FoodTrayComponent

const MAX_SPEED := 125.0
const ACCELERATION_SMOOTHING = 25.0

func _ready() -> void:
	GameEvents.dish_collected.connect(_on_dish_collected)
	GameEvents.dish_disposed.connect(_on_dish_disposed)
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

func is_foodtray_empty():
	return food_tray_component.get_collected_dish() == Globals.FOOD_TYPE.EMPTY


func change_indicator(_foodId: Globals.FOOD_TYPE):
	if indicator_comp == null:
		printerr("Indicator comp in player not defined.")
		return
	indicator_comp.set_food_id(_foodId)

func _on_tray_item_released():
	if indicator_comp == null:
		printerr("Indicator comp in player not defined.")
		return
	indicator_comp.set_food_id(-1)
	print("food_id: ", indicator_comp.food_id)


func _on_dish_collected(_foodId: Globals.FOOD_TYPE):
	change_indicator(_foodId)


func _on_dish_disposed():
	change_indicator(Globals.FOOD_TYPE.EMPTY)
