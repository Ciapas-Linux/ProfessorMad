class_name Hero extends CharacterBody2D

# ######################################
# #   🌟🌟🌟 MAIN PLAYER SCRIPT 🌟🌟🌟 #
# ######################################



# Horizontal walk speed in pixels per second.
@export var speed :float = 250.0

# run speed
@export var speed_run :float = 600.0

# run jump impulse ...
@export var jump_impulse_run :float = 1700.0

# Vertical acceleration in pixel per second squared.
@export var gravity :float = 2000.0

# Vertical speed applied when jumping.
@export var jump_impulse : float = 1200.0

@export var left_walk_limit :float = -1400.0

@export var spawn_point :float = -500.0

@onready var Player_fsm:StateMachine
var Player_level:int = 1
var Player_health:int = 100
const Player_health_max:int = 100
var Player_tilt:int = 0
var Player_gold:int = 0
var Player_direction:Vector2 = Vector2.RIGHT
var Player_is_paused:bool = false
var Player_on_screen:bool = true
var Player_current_weapon:int = 0
var Player_weapon:Sprite2D
var Player_up_down:int = 0 # 0:flat 1:up 2:down
var Player_state:String

signal bomb_hit_me

var eyes_rnd_blink_timer:Timer



# Skeleton2D/Base/Leg_R/Calf_R/Foot_R/RemoteTransform2D
@onready var Foot_R:RemoteTransform2D = get_node("Skeleton2D/Base/Leg_R/Calf_R/Foot_R/RemoteTransform2D")
@onready var Foot_L:RemoteTransform2D = get_node("Skeleton2D/Base/Leg_L/Calf_L/Foot_L/RemoteTransform2D")

@onready var SlopeRayCast:RayCast2D = get_node("RayCast2D")

@onready var anim_player : AnimationPlayer = get_node("AnimationPlayer")

func _ready():
	Player_fsm = get_node("StateMachine")
	$BloodSplash.visible = false
	gv.Player = self

	$Body_parts/Head/powieka_P.visible = false
	$Body_parts/Head/powieka_L.visible = false

	if FileAccess.file_exists("user://game.dat") == false:
		gv.save_player_data()
	else:
		gv.load_player_data()	
	
	gv.load_inventory(0)

	eyes_rnd_blink_timer = Timer.new()
	add_child(eyes_rnd_blink_timer)
	eyes_rnd_blink_timer.wait_time = 5
	eyes_rnd_blink_timer.one_shot = true
	eyes_rnd_blink_timer.connect("timeout", _on_eyes_blink_timer_timeout)
	eyes_rnd_blink_timer.start(randf_range(1.0,10.0))

	print("")
	print("Node ready:" + self.name)  
	print("Player level: " + str(Player_level)) 
	print("Player current weapon: " + str(Player_current_weapon))
	print("Player money: " + str(Player_gold))
	print("Player state: " + Player_fsm.state.name)  
	print("Player start x: " + str(global_position.x))	
	print("Player ready: Yes ...") 
	print("")  	

func fade_in():
	$Body_parts/Arm_L.self_modulate = Color(1, 1, 1, 1)
	$Body_parts/Hand_L.self_modulate = Color(1, 1, 1, 1)
	$Body_parts/Hand_L/ForeArm_L.self_modulate = Color(1, 1, 1, 1)

	$Body_parts/Arm_R.self_modulate = Color(1, 1, 1, 1)
	$Body_parts/Arm_R/Hand_R.self_modulate = Color(1, 1, 1, 1)
	$Body_parts/Arm_R/ForeArm_R.self_modulate = Color(1, 1, 1, 1)
	
	
	$Body_parts/Leg_L.self_modulate = Color(1, 1, 1, 1)
	$Body_parts/Leg_L/Foot_L.self_modulate = Color(1, 1, 1, 1)
	$Body_parts/Leg_L/Foot_L/Calf_L.self_modulate = Color(1, 1, 1, 1)
	
	$Body_parts/Leg_R.self_modulate = Color(1, 1, 1, 1)
	$Body_parts/Leg_R/Foot_R.self_modulate = Color(1, 1, 1, 1)
	$Body_parts/Leg_R/Foot_R/Calf_R.self_modulate = Color(1, 1, 1, 1)
	
	$Body_parts/Body.self_modulate = Color(1, 1, 1, 1)
	
	$Body_parts/Head.self_modulate = Color(1, 1, 1, 1)
	$Body_parts/Head/powieka_P.self_modulate = Color(1, 1, 1, 1)
	$Body_parts/Head/powieka_L.self_modulate = Color(1, 1, 1, 1)

func _on_eyes_blink_timer_timeout():
	if $Body_parts/Head/powieka_P.visible == true:
		open_eyes()
		eyes_rnd_blink_timer.start(randf_range(2,10))
	else:
		close_eyes()
		eyes_rnd_blink_timer.start(randf_range(0.3,2))	

func blink_eyes(_time:float):
	close_eyes()
	await get_tree().create_timer(_time).timeout
	open_eyes()

func close_left_eye():
	$Body_parts/Head/powieka_L.visible = true

func close_right_eye():
	$Body_parts/Head/powieka_P.visible = true

func open_left_eye():
	$Body_parts/Head/powieka_L.visible = false

func open_right_eye():
	$Body_parts/Head/powieka_P.visible = false

func open_eyes():
	open_left_eye()
	open_right_eye()

func close_eyes():
	close_left_eye()
	close_right_eye()	

func is_eyes_open():
	if $Body_parts/Head/powieka_P.visible == true and $Body_parts/Head/powieka_L.visible == true:
		return false
	else:
		return true	

func _process(_delta: float) -> void:
	if global_position.x < left_walk_limit:
		global_position.x = spawn_point
		Player_fsm.transition_to("Idle")

func get_state():
	return Player_fsm.state.name

func on_gun_fire() -> void:
	if Player_direction == Vector2.RIGHT:
		position.x -= 3
	else:	
		position.x += 3
	#print("Player: Shooting ...")
	
func hit():
	print("Player: enemies hit me by bullet!") 
	if Player_health > 0:
		Player_health -= 10
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	Player_on_screen = false

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	Player_on_screen = true

func _on_left_area_2d_area_entered(area:Area2D) -> void:
	if area.name == "Bomb2":
		Player_health -= 25
		Player_fsm.transition_to("Shockwave", {back_area = true}) 	
		print("Left PlayerArea2D hit by: " + area.name) 

func _on_right_area_2d_area_entered(area:Area2D) -> void:
	if area.name == "Bomb2":
		Player_health -= 25
		Player_fsm.transition_to("Shockwave", {front_area = true}) 
		print("Right PlayerArea2D hit by: " + area.name)

func _on_left_area_2d_body_entered(body:Node2D) -> void:
	print("Left PlayerArea enter body: " + body.name) 


func _on_right_area_2d_body_entered(body:Node2D) -> void:
	print("Right PlayerArea enter body: " + body.name) 

func bomb_explode():
	if Player_health > 0:
		Player_health -= 25	
	print("Player: enemies hit me by drone big bomb!")
	Player_fsm.transition_to("Hit_bomb")












