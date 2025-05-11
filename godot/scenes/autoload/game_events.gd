extends Node

signal interactor_area_entered
signal interactor_area_exited
signal ready_to_order
signal request_complete
signal kitchen_interacted
signal meal_served
signal tray_checked

func emit_meal_served(_food_wanted: Globals.FOOD_TYPE):
	meal_served.emit(_food_wanted)

func emit_kitchen_interacted():
	kitchen_interacted.emit()

func emit_ready_to_order(id: int, food_type: Globals.FOOD_TYPE, tip: int):
	ready_to_order.emit(id, food_type, tip)

func emit_request_complete(finished_request):
	request_complete.emit(finished_request)

func emit_tray_checked(result: bool):
	tray_checked.emit(result)
