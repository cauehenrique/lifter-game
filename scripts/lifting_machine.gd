extends Area2D

var player_touching : bool = false
var lift_active : bool = false

var player_node : KinematicBody2D

onready var interact_sprite : Sprite = $interact_sprite
onready var sprite : AnimatedSprite = $sprite
onready var power_timer : Timer = $power_timer
onready var lift_sound : AudioStreamPlayer = $lift_sound

var player_scene : PackedScene = preload("res://scenes/player.tscn")

func _ready() -> void:
	connect("body_entered", self, "body_entered")
	connect("body_exited", self, "body_exited")
	
	power_timer.connect("timeout", self, "power_timer_timeout")
	
func body_entered(body : Node) -> void:
	if body.is_in_group("enemies"):
		Global.end_game()
		
		sprite.play("gordo")
		power_timer.stop()
		
		body.queue_free()
	else:
		player_touching = true
		interact_sprite.visible = true
		
		player_node = body
		
func body_exited(body : Node) -> void:
	if not body.is_in_group("enemies"):
		player_touching = false
		
		if not lift_active:
			interact_sprite.visible = false
		
		player_node = null

func power_timer_timeout() -> void:
	Global.gain_power(10)
	
	lift_sound.pitch_scale = rand_range(0.8, 1)
	lift_sound.play()

func _input(event: InputEvent) -> void:
	if Global.game_over:
		return
	
	if event.is_action_pressed("player_lift"):
		if player_node != null and player_touching:
			sprite.play("enabled")
			
			lift_active = true
			power_timer.start()
			
			player_node.queue_free()
			player_node = null
			
		elif lift_active:
			sprite.play("disabled")
			
			lift_active = false
			power_timer.stop()
			
			player_node = null
			
			# Takes care of spawning the player:
			var player_instance : KinematicBody2D = player_scene.instance()
			
			player_instance.global_position = global_position
			Utils.get_main_node().add_child(player_instance)
