extends Node
class_name VelocityComponent

var direction := Vector2.ZERO
var velocity := Vector2.ZERO

@export var character: CharacterBody2D
@export var max_speed := 125.0
@export var acceleration_smoothing = 25.0

func _physics_process(delta: float) -> void:
	var target_velocity =  direction * max_speed
	velocity = velocity.lerp(target_velocity, 1 - exp(- delta * acceleration_smoothing))
	move_character()

func move_character():
	if character == null:
		return
	character.velocity = velocity
	character.move_and_slide()
