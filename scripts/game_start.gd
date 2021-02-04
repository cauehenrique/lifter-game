extends Control

onready var animation_player : AnimationPlayer = $animation_player

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_lift") and not Global.game_start:
		Global.start_game()
		animation_player.play("go_away")
		
		get_tree().set_input_as_handled()
