extends KinematicBody2D

const GRAV_FORCE : float = 15.0

var velocity : Vector2 = Vector2(0, -100)

onready var sprite : Sprite = $sprite
onready var collision : CollisionShape2D = $collision
onready var death_sound : AudioStreamPlayer = $death_sound
onready var free_timer : Timer = $free_timer

func _ready() -> void:
	Global.player_score += 1
	
	death_sound.pitch_scale = rand_range(0.8, 1)
	death_sound.play()
	
	free_timer.connect("timeout", self, "queue_free")

func _process(delta: float) -> void:
	sprite.rotation_degrees += velocity.x * 0.01

func _physics_process(delta: float) -> void:
	velocity.y += GRAV_FORCE
	
	if is_on_floor():
		if velocity.x > 0:
			velocity.x = max(velocity.x - 1, 0)
		else:
			velocity.x = min(velocity.x + 1, 0)
		
		if abs(velocity.x) <= 0:
			set_physics_process(false)
			collision.disabled = true
		
	velocity = move_and_slide(velocity, Vector2.UP)
