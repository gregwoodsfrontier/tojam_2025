extends CanvasLayer

@export var arean_time_manager: Node
@onready var label: Label = %Label


func _process(delta):
	if arean_time_manager == null:
		return
	var time_elapsed = arean_time_manager.get_time_elapsed()
	label.text = format_seconds_to_string(time_elapsed)


func format_seconds_to_string(sec: float):
	var minutes = floor(sec/60)
	var remaining_seconds = sec - (minutes * 60)
	return "%d"%minutes + ":" + ("%02d" % floor(remaining_seconds))
