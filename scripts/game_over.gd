extends Control

onready var animation_player : AnimationPlayer = $animation_player

func _ready() -> void:
	Global.connect("game_over", self, "setup_game_over")
	
func setup_game_over() -> void:
	animation_player.play("game_over")
