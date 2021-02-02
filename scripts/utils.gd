extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_restart"):
		get_tree().reload_current_scene()
	
func get_main_node() -> Node:
	return get_tree().current_scene

func get_main_camera() -> Node:
	return get_main_node().find_node("camera")
