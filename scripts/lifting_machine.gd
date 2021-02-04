extends Area2D

enum LiftStates { DISABLED, ENABLED, GORDO }
var state : int = LiftStates.DISABLED

var player_touching : bool = false
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
	if not Global.game_start:
		return
	
	if body.is_in_group("enemies"):
		# Global will emmit the "game_over" signal.
		
		# Node related stuff:
		sprite.play("gordo")
		power_timer.stop()
		body.queue_free()
		
		# For some reason, if I don't put this boy down here, the "gordo"
		# spawns an corpse inside the "lifting_machine"...
		yield(get_tree(), "idle_frame")
		Global.end_game()
		
		# This state doesn't have anything in it.
		# And it's going to be perfect, because we don't want
		# the lift_machine to do nothing when the game is already over.
		state = LiftStates.GORDO
	else:
		player_node = body
		player_touching = true
		
		if state == LiftStates.DISABLED:
			interact_sprite.visible = true
	
func body_exited(body : Node) -> void:
	if not Global.game_start:
		return
	
	if not body.is_in_group("enemies"):
		player_touching = false
		player_node = null
		
		if state == LiftStates.DISABLED:
			interact_sprite.visible = false

func power_timer_timeout() -> void:
	Global.gain_power(10)
	
	lift_sound.pitch_scale = rand_range(0.8, 1)
	lift_sound.play()

func _input(event: InputEvent) -> void:
	# Finally, I got rid of the "creating a clone" bug!
	if event.is_action_pressed("player_lift"):
		match state:
			LiftStates.DISABLED:
				if player_touching and player_node != null:
					player_node.queue_free()
					player_node = null
					
					sprite.play("enabled")
					power_timer.start()
					
					state = LiftStates.ENABLED
			
			LiftStates.ENABLED:
				var player_instance : KinematicBody2D = player_scene.instance()
				player_instance.global_position = global_position
				
				Utils.get_main_node().add_child(player_instance)
				
				sprite.play("disabled")
				power_timer.stop()
				
				state = LiftStates.DISABLED
