extends Node

@onready var spawn_timer: Timer = $SpawnTimer
@onready var chair_groups := get_tree().get_nodes_in_group("chair")

@export var customer_scene : PackedScene
@export var spawn_point_group: Array[Marker2D]

func _ready():
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func spawn_customer(px: float, py: float):
	if customer_scene == null:
		return
	var customer_instance = customer_scene.instantiate() as Node2D
	add_child(customer_instance)
	customer_instance.global_position.x = px
	customer_instance.global_position.y = py

func _on_spawn_timer_timeout():
	if spawn_point_group.size() == 0:
		return
	var spawn_point = spawn_point_group.pick_random() as Marker2D
	spawn_customer(spawn_point.global_position.x, spawn_point.global_position.y)
