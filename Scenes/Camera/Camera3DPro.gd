class_name Camera3DPro extends Camera3D

# ###################################
# # .SCRIPT      Camera3DPro
# ###################################

@export var jump_offset : float = 0.2
@export var cam_Y_offset:float = -2300.0
@export var cam_X_offset:float = 0.0


var camera_shake_intensity:float = 0.0
var camera_shake_duration:float = 0.0
var shake: bool = false


func _ready() -> void:
	pass
	

func _physics_process(_delta) -> void:
	position.x = gv.Player3d.global_position.x
	#position.y = (gv.Player3d.global_position.y + cam_Y_offset) * jump_offset
	pass

func _process(delta):
	if (shake == true):
		if camera_shake_duration <= 0:
			self.offset = Vector2.ZERO
			camera_shake_intensity = 0.0
			camera_shake_duration = 0.0
			shake = false
			return
		
		camera_shake_duration = camera_shake_duration - delta
	
		# Shake it
		var _offset:Vector2 = Vector2.ZERO
		_offset = Vector2( randf(), randf() ) * camera_shake_intensity
		self.offset = _offset	

func ScreenShake(intensity: float, duration: float):
	shake = true
	if intensity > camera_shake_intensity and duration > camera_shake_duration:
		camera_shake_intensity = intensity
		camera_shake_duration = duration	
	
		
