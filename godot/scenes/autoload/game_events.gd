extends Node

signal interactor_area_entered
signal interactor_area_exited
signal ready_to_order

func emit_ready_to_order(id: int):
	ready_to_order.emit(id)
