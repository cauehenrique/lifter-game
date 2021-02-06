extends Node

signal player_power_changed(new_power)
signal player_score_changed(new_score)

signal game_start()
signal game_over()

signal dark_mode(is_dark)

var player_score : int = 0 setget set_score
var player_power : int = 100 setget set_power

var game_start : bool = false
var game_over : bool = false

var last_sound_db : float = 10.0
var last_music_db : float = 10.0

var dark_mode : bool = false setget set_dark_mode

# Save and Load stuff:
const SAVE_PATH : String = "user://save.dat"
var best_score : int = 0
var last_score : int = 0

func _ready() -> void:
	load_progress()

func save_progress() -> void:
	var data : Dictionary = {
		"best_score": best_score,
		"last_score": last_score
	}
	
	var file : File = File.new()
	
	var error : int = file.open(SAVE_PATH, File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()
	
	print("Saved Progress: " + str(last_score) + " | " + str(best_score))

func load_progress() -> void:
	var file : File = File.new()
	if file.file_exists(SAVE_PATH):
		var error : int = file.open(SAVE_PATH, File.READ)
		if error == OK:
			var player_data : Dictionary = file.get_var()
			
			last_score = player_data.last_score
			best_score = player_data.best_score
			
			file.close()
			
			print("Loaded Progress: " + str(last_score) + " | " + str(best_score))

func start_game() -> void:
	emit_signal("game_start")
	game_start = true

func end_game() -> void:
	last_score = player_score
	if last_score > best_score:
		print("Last Score > Best Score")
		best_score = last_score
	
	save_progress()
	
	emit_signal("game_over")
	game_over = true

func set_score(new_score : int) -> void:
	player_score = new_score
	emit_signal("player_score_changed", player_score)
	
func set_power(new_power : int) -> void:
	player_power = new_power
	emit_signal("player_power_changed", player_power)

func lose_power(amount : int) -> void:
	set_power(int(max(player_power - amount, 0)))

func gain_power(amount : int) -> void:
	set_power(int(min(player_power + amount, 100)))

func set_dark_mode(is_dark : bool) -> void:
	dark_mode = is_dark
	emit_signal("dark_mode", dark_mode)

func reset_values() -> void:
	game_start = false
	game_over = false
	
	player_score = 0
	player_power = 100
