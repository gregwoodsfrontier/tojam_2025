extends Node

signal interactor_area_entered
signal interactor_area_exited
signal ready_to_order
signal request_complete
signal kitchen_interacted
signal meal_served
signal tray_checked
signal tip_given
signal customer_leaving
signal food_collected_by_tray
signal tray_item_released
signal seat_assigned(_id: int, _chair: Chair)
signal dish_disposed
signal dish_collected(food_id: Globals.FOOD_TYPE)

func emit_dish_disposed():
	dish_disposed.emit()

func emit_dish_collected(food_id: Globals.FOOD_TYPE):
	dish_collected.emit(food_id)

func emit_seat_assigned(_id: int, _chair: Chair):
	seat_assigned.emit(_id, _chair)

func emit_tray_item_released():
	tray_item_released.emit()

func emit_food_collected(_foodId: Globals.FOOD_TYPE):
	food_collected_by_tray.emit(_foodId)

func emit_customer_leaving(id: int):
	customer_leaving.emit(id)

func emit_tip_given(_value: int):
	tip_given.emit(_value)

func emit_meal_served(_id: int, _food_wanted: Globals.FOOD_TYPE):
	meal_served.emit(_id, _food_wanted)

func emit_kitchen_interacted():
	kitchen_interacted.emit()

func emit_ready_to_order(id: int, food_type: Globals.FOOD_TYPE, tip: int):
	ready_to_order.emit(id, food_type, tip)

func emit_request_complete(finished_request):
	request_complete.emit(finished_request)

func emit_tray_checked(_id: int, result: bool):
	tray_checked.emit(_id, result)
