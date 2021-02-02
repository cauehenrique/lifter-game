extends KinematicBody2D

const GRAV_FORCE : float = 15.0

var velocity : Vector2 = Vector2(0, -100)

onready var sprite : Sprite = $sprite
onready var collision : CollisionShape2D = $collision

onready var death_sound : AudioStreamPlayer = $death_sound

func _ready() -> void:
	Global.add_score()
	
	death_sound.pitch_scale = rand_range(0.8, 1)
	death_sound.play()

func _process(delta: float) -> void:
	sprite.rotation_degrees += velocity.x * 0.01

func _physics_process(delta: float) -> void:
	velocity.y += GRAV_FORCE
	
	if is_on_floor():
		velocity.x = max(velocity.x - 0.5, 0)
		if velocity.x <= 0:
			set_physics_process(false)
			collision.disabled = true
		
	velocity = move_and_slide(velocity, Vector2.UP)
