extends Node

var camera_shake_intensity:float = 0.0
var camera_shake_duration:float = 0.0
var camera:Camera2D
var player:Hero

func _ready():
	camera = get_tree().current_scene.get_node_or_null("Camera2DPro")
	if !camera:
		player = get_tree().current_scene.get_node_or_null("Player")
		if !player:
			print("WARNING: no 2D Camera for screen shake ...")
		else:
			camera = get_tree().current_scene.get_node_or_null("Player").get_node_or_null("Camera2DPro")	

func shake(intensity, duration):
	if intensity > camera_shake_intensity and duration > camera_shake_duration:
		camera_shake_intensity = intensity
		camera_shake_duration = duration

func _process(delta):
	#if !camera:
		#return
	
	# Stop shaking if the camera_shake_duration timer is down to zero
	if camera_shake_duration <= 0:
		camera.offset = Vector2.ZERO
		camera_shake_intensity = 0.0
		camera_shake_duration = 0.0
		return
	
	camera_shake_duration = camera_shake_duration - delta
	
	# Shake it
	var offset = Vector2.ZERO
	offset = Vector2(randf(), randf()) * camera_shake_intensity
	camera.offset = offset

	# print("WARNING: screen shake ...")	
