extends ColorRect

func _ready() -> void:
	Global.connect("dark_mode", self, "change_mode")

func change_mode(is_dark : bool) -> void:
	visible = is_dark
