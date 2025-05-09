extends CharacterBody2D

@onready var interactable: Interactable = $Interactable

func _ready():
	interactable.interact = Callable(self, "_on_interact")

func _on_interact():
	print("interacted!!")
