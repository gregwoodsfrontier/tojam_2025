extends Node2D

@export var request_manager: RequestManager

@onready var progress_bar: ProgressBar = %ProgressBar

var cooking_percent = 0.0

func _process(delta: float) -> void:
	if request_manager == null:
		printerr("chef. request manager reference is null.")
		return
	var proc_timer = request_manager.process_timer
	if proc_timer.is_stopped():
		hide_progress_bar()
		return
	show_progress_bar()
	update_progress_display(get_progress_percent())


func get_progress_percent():
	return request_manager.process_timer.time_left / request_manager.process_timer.wait_time


func hide_progress_bar():
	progress_bar.visible = false


func show_progress_bar():
	progress_bar.visible = true


func update_progress_display(value):
	progress_bar.value = value
