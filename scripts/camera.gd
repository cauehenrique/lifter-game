extends Camera2D

onready var shake_tween : Tween = $shake_tween

func _ready() -> void:
	randomize()

func shake_camera(shake_vector : Vector2) -> void:
	offset = Vector2(rand_range(-shake_vector.x, shake_vector.x), rand_range(-shake_vector.y, shake_vector.y))

func shake(shake_force : float, shake_duration : float) -> void:
	shake_tween.interpolate_method(self, "shake_camera", Vector2(shake_force, shake_force), Vector2.ZERO, shake_duration, Tween.TRANS_SINE, Tween.EASE_OUT, 0)
	shake_tween.start()
