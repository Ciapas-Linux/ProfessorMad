
# ###################################
# # .SCRIPT      Camera2DPro
# ###################################


class_name Camera2DPro extends Camera2D

# Lower cap for the `_zoom_level`.
@export var min_zoom: float = 0.3
# Upper cap for the `_zoom_level`.
@export var max_zoom : float = 2.0
# Controls how much we increase or decrease the `_zoom_level` on every turn of the scroll wheel.
@export var zoom_factor : float = 0.1
# Duration of the zoom's tween animation.
@export var zoom_duration : float = 0.6

@export var jump_offset : float = 0.2

var target_position : Vector2

var follow_node:Node2D

var _zoom_level : float = 0.5
var zoom_step : float = 1.1
var zoom_speed: float = 0.05

var camera_shake_intensity:float = 0.0
var camera_shake_duration:float = 0.0
var shake: bool = false

var _velocity = Vector2.ZERO
const SLOW_RADIUS :float = 300.0
@export var max_speed : float = 2000.0
@export var mass :float = 2.0
var distance_to_target : float = 0.0
var desired_velocity : Vector2

@export var cam_Y_offset:float = -2300.0
@export var cam_X_offset:float = 0.0

var old_position: Vector2

const IDLE:int = 0
const FOLLOW_TARGET:int = 1
const MOVE_TO_TARGET:int = 2
const MOVE_TO_TARGET_X:int = 3


var current_state : int = IDLE
var previous_state : int = IDLE


func _ready():
	self.drag_right_margin = -0.3
	self.drag_left_margin = 0.8
	set_zoom_level(_zoom_level)
	SetState(IDLE)		


func _physics_process(delta):
	match current_state:
		IDLE:
			_process_on_state_idle(delta)
		FOLLOW_TARGET:
			_process_on_state_follow(delta)
		MOVE_TO_TARGET_X:
			_process_on_state_move_x(delta)
		MOVE_TO_TARGET:
			_process_on_state_move(delta)				
	
	gv.Cam1_global_position = position
	
	#position.x += 10
	#print("mx: " + str(get_viewport().get_mouse_position().x) + "   " + "my :" + str(get_viewport().get_mouse_position().y))
	

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

func _process_on_state_idle(_delta):
	pass

func _process_on_state_follow(_delta):
	if get_viewport().get_mouse_position().x > gv.SWidth - 50:
		position.x += 20
		return
	else:
		if get_viewport().get_mouse_position().x <  100:
			position.x -= 20	
		else:
			if gv.Hero_on_screen == true:
				position.x = follow_node.global_position.x
				position.y = (follow_node.global_position.y + cam_Y_offset) * jump_offset
	

func _process_on_state_move_x(_delta):
	distance_to_target = position.distance_to(target_position)
	if (distance_to_target <= 900.0):
		SetState(IDLE)		
		set_zoom_level(_zoom_level)
		
	#if (global_position.x > target_position.x - 50 and global_position.x < target_position.x + 50):
		#current_state = IDLE
	position.x += 50.0
	#print("target: " , distance_to_target)

func _process_on_state_move(_delta):
	distance_to_target = position.distance_to(target_position)
	desired_velocity = (target_position - position).normalized() * max_speed * zoom.x
	if distance_to_target < SLOW_RADIUS * zoom.x:
		desired_velocity *= (distance_to_target / (SLOW_RADIUS * zoom.x))
	_velocity += (desired_velocity - _velocity) / mass
	position += _velocity * _delta

func SetFollowNode(target):
	follow_node = target
	position.x = follow_node.global_position.x
	position.y = follow_node.global_position.y + cam_Y_offset * jump_offset
	SetState(FOLLOW_TARGET)		

func SetState(state: int):
	previous_state = current_state
	current_state = state	

func ScreenShake(intensity: float, duration: float):
	shake = true
	if intensity > camera_shake_intensity and duration > camera_shake_duration:
		camera_shake_intensity = intensity
		camera_shake_duration = duration	
	
func Move_to_x(_position: Vector2) -> void:
	target_position = _position
	SetState(MOVE_TO_TARGET_X)

func Move_to(_position: Vector2) -> void:
	target_position = _position
	SetState(MOVE_TO_TARGET)


# Vector2(1.8,1.8), tm 6 , pt 2
func Tween_to(_position: Vector2,_offset:Vector2,_zoom:Vector2,_zoom_time:float,_position_time:float) -> void:
	old_position = global_position
	#target_position = _position
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(tween.TRANS_SINE)

	#var tween_callback = func():
	#	SetState(IDLE)
		#set_zoom_level(_zoom_level)	
		#global_position = old_position 
		

	#tween.tween_callback(tween_callback).set_delay(8)
	tween.tween_property(self, "zoom", _zoom, _zoom_time)
	#_position.y = _position.y + 900
	#_position.x = _position.x - 300
	tween.tween_property(self, "global_position", _position + _offset, _position_time)
	SetState(IDLE)				

func set_zoom_level(value: float) -> void:
	_zoom_level = clamp(value, min_zoom, max_zoom)
	var tween:Tween = create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(tween.TRANS_SINE)
	tween.tween_property(self, "zoom", Vector2(_zoom_level,_zoom_level), zoom_duration)
	


# func _unhandled_input(event):
# 	if event.is_action_pressed("zoom_in"):
# 		#_zoom_at_point2(zoom_step,get_global_mouse_position())
# 		#zoom_camera(-zoom_speed, get_global_mouse_position())
# 		set_zoom_level(_zoom_level - zoom_factor)
# 	if event.is_action_pressed("zoom_out"):
# 		set_zoom_level(_zoom_level + zoom_factor)
# 		#_zoom_at_point2(1/zoom_step,get_global_mouse_position())
# 		#zoom_camera(zoom_speed, event.position)













#############################################
############ GARBAGE           ###############
#############################################
 


# look_at(get_global_mouse_position())

#position.x = gv.Hero_global_position.x
#position.y = gv.Hero_global_position.y * 0.1 - 410

#position.x = gv.Enemy_global_position.x
#position.y = gv.Enemy_global_position.y * 0.1 - 410


""" func zoom_at_point(zoom_change, point):
	var c0 = global_position # camera position
	var v0 = get_viewport().size # vieport size
	var c1 # next camera position
	var z0 = zoom # current zoom value
	var z1 = z0 * zoom_change # next zoom value
	c1 = c0 + (-0.5*v0 + point)*(z0 - z1)
	zoom = z1
	global_position = c1
	
func zoom_at_point2(zoom_change, mouse_position):
		scale = scale * zoom_change
		var delta_x = (mouse_position.x - global_position.x) * (zoom_change - 1)
		var delta_y = (mouse_position.y - global_position.y) * (zoom_change - 1)
		global_position.x = global_position.x - delta_x
		global_position.y = global_position.y - delta_y

func zoom_camera(zom_factor, mouse_position):
	var viewport_size = get_viewport().size
	var previous_zoom = zoom
	zoom += zoom * zom_factor
	offset += ((viewport_size * 0.5) - mouse_position) * (zoom-previous_zoom)
 """
