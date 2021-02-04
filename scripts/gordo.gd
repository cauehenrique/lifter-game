extends KinematicBody2D

const MOVE_SPEED : float = 20.0
const JUMP_FORCE : float = 150.0
const GRAV_FORCE : float = 15.0

var move_dir : int = 1
var velocity : Vector2 = Vector2()

var gordo_corpse : PackedScene = preload("res://scenes/gordo_corpse.tscn")

onready var hurtbox : Area2D = $hurtbox
onready var sprite : AnimatedSprite = $sprite

func _ready() -> void:
	add_to_group("enemies")
	
	Global.connect("game_over", self, "queue_free")
	hurtbox.connect("area_entered", self, "hurtbox_area_entered")
	
	var lifting_machine : Area2D = get_parent().get_node("lifting_machine")
	move_dir = sign(int(lifting_machine.global_position.x - global_position.x))

	if move_dir > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func _physics_process(_delta: float) -> void:
	velocity.y += GRAV_FORCE
	velocity.x = move_dir * MOVE_SPEED
	
	if is_on_wall() and is_on_floor():
		velocity.y = -JUMP_FORCE
	
	velocity = move_and_slide(velocity, Vector2.UP)

func hurtbox_area_entered(_area : Area2D) -> void:
	death()
	
func death() -> void:
	var corpse_instance : KinematicBody2D = gordo_corpse.instance()
	
	corpse_instance.velocity.x = move_dir * 50.0
	corpse_instance.global_position = global_position
	
	Utils.get_main_node().call_deferred("add_child", corpse_instance)
	
	queue_free()
