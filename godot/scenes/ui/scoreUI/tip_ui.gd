extends CanvasLayer

@export var tip_manager: Node
@onready var label: Label = $MarginContainer/HBoxContainer/Label

func _process(delta: float) -> void:
	if tip_manager == null:
		print("tip manager undefined")
	var tip_get = tip_manager.get_tip()
	label.text = str(tip_get)
