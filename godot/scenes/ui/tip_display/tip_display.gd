extends Control

@export var tip_manager: Node
@onready var tip_label: Label = %TipLabel

func _process(delta: float) -> void:
	if tip_manager == null:
		print("tip manager undefined")
	var tip_get = tip_manager.get_tip()
	tip_label.text = str(tip_get)
