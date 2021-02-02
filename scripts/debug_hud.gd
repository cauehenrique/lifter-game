extends Control

onready var current_fps_label : Label = $margin_container/panel_container/vbox_debug/current_fps_label
onready var current_scene_label : Label = $margin_container/panel_container/vbox_debug/current_scene_label
onready var node_count_label : Label = $margin_container/panel_container/vbox_debug/node_count_label

var debug_visible : bool = false

func _ready() -> void:
	visible = debug_visible

func _process(delta: float) -> void:
	if not debug_visible:
		return
	
	current_fps_label.text = "fps: " + str(Engine.get_frames_per_second())
	current_scene_label.text = "scene: " + str(get_tree().current_scene.name)
	node_count_label.text = "node_count: " + str(get_tree().get_node_count())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_visible"):
		debug_visible = !debug_visible
		visible = debug_visible
