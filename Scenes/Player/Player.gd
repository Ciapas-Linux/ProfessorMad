class_name Hero extends CharacterBody2D

# ######################################
# #   🌟🌟🌟 MAIN PLAYER SCRIPT 🌟🌟🌟 #
# ######################################



# Horizontal walk speed in pixels per second.
@export var speed :float = 250.0

# run speed
@export var speed_run :float = 600.0

# run jump impulse
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
var Player_guns = {"no": 0, "ak_47": 1, "rpg_7": 2, "rocket_4": 3}
var Player_current_weapon:int = Player_guns["ak_47"]
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
	
	
	############################ !!!!!!!!!!!!!!!!	
	Player_current_weapon = 0
	############################ !!!!!!!!!!!!!!!!

	load_inventory()

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

func load_inventory():  # Body_parts/Arm_R/Hand_R/weapon_spawn
						# Torso/arm_r/weapon_spawn
						# Torso/arm_r
	
	#var spawn_node_path:String = "Body_parts/weapon_spawn"
	#var marker_node_path:String = "Body_parts/weapon_spawn"
	
	match Player_current_weapon:
		0: # Empty weapon = none
			if get_node("Body_parts/weapon_spawn/rocket_4").get_child_count() > 0:
				get_node("Body_parts/weapon_spawn/rocket_4").get_child(0).queue_free()
			Player_weapon = load("res://Scenes/Weapons/Empty/Empty_gun.tscn").instantiate()
			if get_node("Body_parts/weapon_spawn/empty").get_child_count() > 0:
				get_node("Body_parts/weapon_spawn/empty").get_child(0).queue_free()
			get_node("Body_parts/weapon_spawn/empty").add_child(Player_weapon)
			gv.set_cursor_orange()	
		
		1: # AK-47 
			get_node("Body_parts/weapon_spawn/empty").get_child(0).queue_free()
			Player_weapon = load("res://Scenes/Weapons/ak_47/AK-47.tscn").instantiate()
			if get_node("Body_parts/weapon_spawn/ak-47").get_child_count() > 0:
				get_node("Body_parts/weapon_spawn/ak-47").get_child(0).queue_free()
			get_node("Body_parts/weapon_spawn/ak-47").add_child(Player_weapon)
			gv.set_cursor_orange()
			Player_weapon.transform = get_node("Body_parts/weapon_spawn/ak-47").transform
			Player_weapon.scale = Vector2(3,3)
		
		2: # RPG-7 Grenade launcher
			get_node("Body_parts/weapon_spawn/ak-47").get_child(0).queue_free()
			Player_weapon = load("res://Scenes/Weapons/rpg_7/rpg_7.tscn").instantiate()
			if get_node("Body_parts/weapon_spawn/rpg_7").get_child_count() > 0:
				get_node("Body_parts/weapon_spawn/rpg_7").get_child(0).queue_free()
			get_node("Body_parts/weapon_spawn/rpg_7").add_child(Player_weapon)
			gv.set_cursor_orange()
			Player_weapon.transform = get_node("Body_parts/weapon_spawn/rpg_7").transform
			Player_weapon.scale = Vector2(5,7)	

		3: # Home misille rocket launcher
			get_node("Body_parts/weapon_spawn/rpg_7").get_child(0).queue_free()
			Player_weapon = load("res://Scenes/Weapons/rocket_4/rocket_4_launcher.tscn").instantiate()
			if get_node("Body_parts/weapon_spawn/rocket_4").get_child_count() > 0:
				get_node("Body_parts/weapon_spawn/rocket_4").get_child(0).queue_free()
			get_node("Body_parts/weapon_spawn/rocket_4").add_child(Player_weapon)
			gv.set_cursor_green()
			Player_weapon.transform = get_node("Body_parts/weapon_spawn/rocket_4").transform
			Player_weapon.scale = Vector2(3,3)		

	print("Player: inventory loaded")

func load_next_weapon():
	# print("Weapons: " + str(Player_guns.size()))
	if Player_guns.size() > Player_current_weapon:
		Player_current_weapon += 1
		load_inventory()
		# Player_guns = {"no": 0, "ak_47": 1, "rpg_7": 2 }
	if Player_guns.size() == Player_current_weapon:
		Player_current_weapon = 0
		load_inventory()

	
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
	print("Hero: enemies hit me by bullet!") 
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
	print("Hero: enemies hit me by drone big bomb!")
	Player_fsm.transition_to("Hit_bomb")












# #################
# # GARBAGE       #
# #################



#@onready var Foot_RR:CharacterBody2D = get_node("Skeleton2D/Base/Leg_R/Calf_R/Foot_R/Sprite2D")
#@onready var Foot_LL:Sprite2D = get_node("Skeleton2D/Base/Leg_L/Calf_L/Foot_L/Sprite2D")


#@onready var But_anim : Animation = get_node("AnimationPlayer").get_animation("walk_2")
	
# var humanoid_profile:SkeletonProfileHumanoid
# var Player_skeleton:Skeleton2D

# node.reparent(new_parent)




# for track_indx in But_anim.get_track_count():
	# 	But_anim.track_get_path(track_indx)
	# 	print("********: " + str(But_anim.track_get_path(track_indx)) + "  :" +  str(track_indx))	


	# But_anim.track_set_enabled (14, false)
	# But_anim.track_set_enabled (15, false)
	# But_anim.track_set_enabled (16, false)
	# But_anim.track_set_enabled (17, false)

	# But_anim.remove_track (17)
	# But_anim.remove_track (16)
	# But_anim.remove_track (15)
	# But_anim.remove_track (14)

	# print("================")

	# for track_indx in But_anim.get_track_count():
	# 	But_anim.track_get_path(track_indx)
	# 	print("********: " + str(But_anim.track_get_path(track_indx)) + "  :" +  str(track_indx))	



# humanoid_profile = SkeletonProfileHumanoid.new()
	# Player_skeleton = $Skeleton2D
	# Player_skeleton.profile = humanoid_profile
	# humanoid_profile.set_bone_name("hips", "Pelvis")
	# humanoid_profile.set_bone_name("spine", "Spine1")
	# humanoid_profile.set_bone_name("chest", "Spine2")
	# humanoid_profile.set_bone_name("upper_arm_l", "LeftArm")
	# humanoid_profile.set_bone_name("upper_arm_r", "RightArm")


	#emit_signal("player_stats_changed", self)









# for node in $Body_parts.get_children():
# 		if node.get_child_count() > 0:
# 			if node.get_class() == "Sprite2D":
# 				node.self_modulate = Color(1, 1, 1, 1)
# 				print("QQQQQQQQ######> " + node.get_name())
# 		else:
# 			node.self_modulate = Color(1, 1, 1, 1)
# 			print("QQQQQQQQ######> " + node.get_name())


#@onready var weapons:Array[Resource] = [preload("res://Scenes/Guns/AK-47.tscn"), preload("res://Scenes/Guns/rpg_7.tscn")]

#@onready var ak_47_res:Resource = preload("res://Scenes/Guns/AK-47.tscn")
#@onready var inventory_res:Resource = preload("res://Scenes/Hero/Inventory/inventory.gd")




#gv.Hero_gold += playerData.money

	#ak_47_res = load("res://Scenes/Guns/AK-47.tscn")

# Load inventory Resource create one if not exist:
	# if ResourceLoader.exists("user://Inventory.tres"):
	# 	playerData = ResourceLoader.load("user://Inventory.tres").duplicate(true)
	# 	print("Hero: load inventory file ...") 
	# else:
	# 	playerData = Inventory.new()
	# 	playerData.money = 5
	# 	playerData.level = 1
	# 	playerData.current_weapon = "ak_47"
	# 	print("Hero: create inventory file ...") 
	# 	ResourceSaver.save(playerData, "user://Inventory.tres")


# extends Node2D

# var scenes = [preload("res://Block.tscn"), preload("res://Player.tscn")]

# func _ready():
# 	for scene in scenes:
# 		add_child(scene.instance())




# # You Use int("234"), str(249), ...

#if turn == true:
		#var pos = position.angle_to_point(get_global_mouse_position())
		#if pos > 0.8 or pos > -1.436: 
		#weapon.global_rotation = rad_to_deg(global_position.angle_to(get_global_mouse_position()))
		
		#weapon.global_rotation = position.angle_to_point(get_global_mouse_position())
		# + 0.035
		
		#weapon.global_rotation = get_global_mouse_position().angle_to_point(position)	
		
		#print_debug(pos)  
	#else:
		#weapon.global_rotation = -3.1 
	

#func _draw():
	#draw_line(marker.global_position, get_global_mouse_position(), Color(255, 255, 0), 1)

#func _draw():
#	draw_line(Vector2(0,0), Vector2(50, 50), Color(255, 0, 0), 1)







#var last_y_mpos = 0
#@onready var fsm := $StateMachine

#if turn == true:
#		weapon.global_rotation = -0.01 + (gv.mouse_pos.y*2) * 0.001
#	else:
#		weapon.global_rotation = -3.1 + (gv.mouse_pos.y*2) * 0.001


	
	#var mpath = gv.mouse_pos.y - last_y_mpos

#var bullet_spawn = get_node("Torso/arm_r/Gun/BulletsSpawn").get_global_position()
#		var distance = gv.mouse_pos - get_node("Torso/arm_r/Gun/BulletsSpawn").get_global_position()
#		var ass = get_node("Torso/arm_r/Gun/BulletsSpawn").get_global_position().distance_to(gv.mouse_pos)
		#var ass2 = distance.length()

		#if ass > 320:
		
		#weapon.global_rotation = distance.angle()

#if Input.is_action_just_pressed("ui_up"):
		
	
#	if turn == true:
#		weapon.global_rotation = -0.01
#	else:
#		weapon.global_rotation = -3.1

	#last_y_mpos = gv.mouse_pos.y	


#if Input.is_action_just_pressed("ui_up"):
		
	
#	if turn == true:
#		weapon.global_rotation = -0.01
#	else:
#		weapon.global_rotation = -3.1

	#last_y_mpos = gv.mouse_pos.y	

#print_debug("gun_fire")  

#if value == false:
		#weapon.set_flip_v(true)

#var normalized = (get_local_mouse_position() - bullet_spawn).normalized()
		#var target = bullet_spawn + normalized * 100
		#drawline(bullet_spawn, target, Color(255, 0, 0, 0.5), 3, true)
		
		#update()
		
		#weapon.global_rotation += 0.01
		#print_debug(mpath)  
		#weapon.global_rotation = -0.01 + (mpath	*0.01)
