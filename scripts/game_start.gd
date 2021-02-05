extends Control

onready var animation_player : AnimationPlayer = $animation_player

onready var sound_slider : HSlider = $volumes_margin/volumes_vbox/sound_hbox/sound_slider
onready var music_slider : HSlider = $volumes_margin/volumes_vbox/music_hbox/music_slider
onready var sound_blip : AudioStreamPlayer = $volumes_margin/volumes_vbox/sound_hbox/test_sound

var music_bus_idx : int = AudioServer.get_bus_index("Music")
var sound_bus_idx : int = AudioServer.get_bus_index("Sound")

const MUSIC_START_DB : int = 12

func _ready() -> void:
	sound_slider.value = Global.last_sound_db
	music_slider.value = Global.last_music_db
	
	sound_slider.connect("value_changed", self, "change_sound_volume")
	music_slider.connect("value_changed", self, "change_music_volume")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_lift") and not Global.game_start:
		Global.start_game()
		animation_player.play("go_away")
		
		get_tree().set_input_as_handled()

func change_sound_volume(new_value : float) -> void:
	print("Sound Slider changed: " + str(new_value))
	
	Global.last_sound_db = new_value
	
	AudioServer.set_bus_mute(sound_bus_idx, (new_value <= 0))
	AudioServer.set_bus_volume_db(sound_bus_idx, (new_value - 10))
	
	sound_blip.play()

func change_music_volume(new_value : float) -> void:
	print("Music Slider changed: " + str(new_value))
	
	Global.last_music_db = new_value
	
	AudioServer.set_bus_mute(music_bus_idx, (new_value <= 0))
	AudioServer.set_bus_volume_db(music_bus_idx, (new_value - 10) - MUSIC_START_DB)
