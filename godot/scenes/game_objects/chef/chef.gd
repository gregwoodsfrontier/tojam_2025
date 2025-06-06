extends Node2D

@onready var progress_bar: ProgressBar = %ProgressBar

var cooking_percent = 0.0

func update_progress_display():
	progress_bar.value = cooking_percent
