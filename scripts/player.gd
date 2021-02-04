extends KinematicBody2D

const MOVE_SPEED : float = 80.0
const JUMP_FORCE : float = 200.0
const GRAV_FORCE : float = 15.0
const STOMP_SPEED : float = 220.0

var velocity : Vector2 = Vector2()

enum PlayerStates { FREE }
var state : int = PlayerStates.FREE

var last_grounded : bool = false
var grounded : bool = false

var smoke_particle : PackedScene  = preload("res://scenes/smoke_particle.tscn")
var player_corpse : PackedScene = preload("res://scenes/player_corpse.tscn")

onready var squash_tween : Tween = $squash_tween
onready var sprite : AnimatedSprite = $sprite
onready var power_timer : Timer = $power_timer

onready var jump_sound : AudioStreamPlayer = $jump_sound
onready var grounded_sound : AudioStreamPlayer = $grounded_sound

func _ready() -> void:
	Global.connect("game_over", self, "death")
	
	power_timer.connect("timeout", self, "power_timer_timeout")

func _physics_process(delta: float) -> void:	
	match state:
		PlayerStates.FREE: player_state_free()
	
	last_grounded = grounded
	grounded = is_on_floor()
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
func horizontal_input() -> int:
	return int(Input.is_action_pressed("player_right")) - int(Input.is_action_pressed("player_left"))
	
func player_state_free() -> void:
	velocity.y += GRAV_FORCE
	
	# Just grounded:
	if grounded != last_grounded and grounded:
		smoke_particles()
		Utils.get_main_camera().shake(1, 0.5)
		
		grounded_sound.pitch_scale = rand_range(0.6, 1)
		grounded_sound.play()
		
		squash_tween.interpolate_property(sprite, "scale", Vector2(1.5, 0.5), Vector2(1, 1), 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
		squash_tween.start()
	
	animate_sprite()
	
	if not Global.game_start:
		return
	
	velocity.x = horizontal_input() * MOVE_SPEED
	if Input.is_action_just_pressed("player_jump") and grounded:
		jump()

func animate_sprite() -> void:
	if grounded:
		if velocity.x != 0:
			sprite.play("walk")
			
			if velocity.x > 0:
				sprite.flip_h = false
			else:
				sprite.flip_h = true
		else:
			sprite.play("idle")
	else:
		sprite.play("jump")

func smoke_particles() -> void:
	var smoke_instance : CPUParticles2D = smoke_particle.instance()
	
	smoke_instance.global_position = global_position
	smoke_instance.restart()
	
	Utils.get_main_node().add_child(smoke_instance)

func power_timer_timeout() -> void:
	if not Global.game_start:
		return
	
	if Global.player_power > 0:
		Global.lose_power(3)
	else:
		death()

func death() -> void:
	var corpse_instance : KinematicBody2D = player_corpse.instance()
	
	corpse_instance.global_position = global_position
	
	Utils.get_main_node().call_deferred("add_child", corpse_instance)
	queue_free()

func jump() -> void:
	velocity.y = -JUMP_FORCE
	
	jump_sound.pitch_scale = rand_range(0.8, 1)
	jump_sound.play()
	
	squash_tween.interpolate_property(sprite, "scale", Vector2(0.5, 1.5), Vector2(1, 1), 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	squash_tween.start()
	
