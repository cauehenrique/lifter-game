extends CPUParticles2D

func _ready() -> void:
	$destroy_timer.wait_time = lifetime
	$destroy_timer.start()
	
	$destroy_timer.connect("timeout", self, "queue_free")
