extends Node

signal player_power_changed(new_power)
signal player_score_changed(new_score)
signal game_over()

var player_score : int = 0 setget set_score
var player_power : int = 100 setget set_power
var game_over : bool = false

func end_game() -> void:
	emit_signal("game_over")
	game_over = true

func set_score(new_score : int) -> void:
	player_score = new_score
	emit_signal("player_score_changed", player_score)
	
func set_power(new_power : int) -> void:
	player_power = new_power
	emit_signal("player_power_changed", player_power)

func lose_power(amount : int) -> void:
	set_power(max(player_power - amount, 0))

func gain_power(amount : int) -> void:
	set_power(min(player_power + amount, 100))

func reset_values() -> void:
	game_over = false
	player_score = 0
	player_power = 100
