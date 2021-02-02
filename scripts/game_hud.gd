extends Control

export (NodePath) var power_progress_path : NodePath
export (NodePath) var score_label_path : NodePath

onready var power_progress : TextureProgress = get_node(power_progress_path)
onready var score_label : Label = get_node(score_label_path)

func _ready() -> void:
	Global.connect("player_power_changed", self, "change_player_power")
	Global.connect("player_score_changed", self, "change_player_score")
	
func change_player_power(new_power : int) -> void:
	power_progress.value = new_power
	
func change_player_score(new_score : int) -> void:
	score_label.text = str(new_score)
