extends Node

var tip_value := 0

func _ready():
	GameEvents.tip_given.connect(_on_tip_given)

func _on_tip_given(_value: int):
	_raise_tip(_value)

func _raise_tip(value: int):
	tip_value += value

func get_tip():
	return tip_value
