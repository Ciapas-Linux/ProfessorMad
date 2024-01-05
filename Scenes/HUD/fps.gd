extends Label


#func _ready():
	#get_node("/root/Events").fps_displayed.connect(_on_fps_displayed)
	
func _process(_delta):
	text = "FPS: %s" % [Engine.get_frames_per_second()]
	
