extends Node

onready var spawn_timer : Timer = $spawn_timer
onready var position_array : Array = [$spawn_point_1, $spawn_point_2]

var gordo_scene : PackedScene = preload("res://scenes/gordo.tscn")

func _ready() -> void:
	spawn_timer.connect("timeout", self, "spawn_timer_timeout")
	
	# When the game_start signal is emmited, starts the timer.
	# When the game_over signal is emitted, stops the timer.
	Global.connect("game_start", spawn_timer, "start")
	Global.connect("game_over", spawn_timer, "stop")

func spawn_timer_timeout() -> void:
	spawn_timer.wait_time = rand_range(1, 2)
	
	var chosen_position : Position2D = position_array[randi() % position_array.size()]
	
	var gordo_instance : KinematicBody2D = gordo_scene.instance()
	
	gordo_instance.global_position = chosen_position.global_position
	Utils.get_main_node().add_child(gordo_instance)
