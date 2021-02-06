extends Control

onready var animation_player : AnimationPlayer = $animation_player

onready var best_score_label : Label = $center_container/v_box_container/score_vbox/best_score_label
onready var last_score_label : Label = $center_container/v_box_container/score_vbox/last_score_label

func _ready() -> void:
	Global.connect("game_over", self, "setup_game_over")
	
func setup_game_over() -> void:
	best_score_label.text = "best score: " + str(Global.best_score)
	last_score_label.text = "last score: " + str(Global.last_score)
	
	animation_player.play("game_over")
