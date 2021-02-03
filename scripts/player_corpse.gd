extends KinematicBody2D

const GRAV_FORCE : float = 15.0

var velocity : Vector2 = Vector2(100, -150)

onready var collision : CollisionShape2D = $collision
onready var death_sound : AudioStreamPlayer = $death_sound

func _ready() -> void:
	death_sound.pitch_scale = rand_range(0.8, 1)
	death_sound.play()

func _physics_process(delta: float) -> void:
	velocity.y += GRAV_FORCE
	
	if is_on_floor():
		velocity.x = max(velocity.x - 5, 0)
		if abs(velocity.x) <= 0:
			set_physics_process(false)
			collision.disabled = true
	
	velocity = move_and_slide(velocity, Vector2.UP)
