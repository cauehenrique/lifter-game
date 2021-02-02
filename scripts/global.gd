extends Node

signal player_power_changed(new_power)
signal player_score_changed(new_score)

var player_score : int = 0 setget set_score
var player_power : int = 0 setget set_power

func set_score(new_score : int) -> void:
	player_score = new_score
	emit_signal("player_score_changed", player_score)
	
func add_score() -> void:
	set_score(player_score + 1)

func set_power(new_power : int) -> void:
	player_power = new_power
	emit_signal("player_power_changed", player_power)
