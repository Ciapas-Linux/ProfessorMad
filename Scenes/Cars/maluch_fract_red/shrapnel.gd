extends GPUParticles2D


func _ready():
	one_shot = true
	emitting = true

func _physics_process(_delta):
	if not emitting:
		#print("hit_particles: Not emitting")
		queue_free()
	#else:
		#print("hit_particles: Emitting")
