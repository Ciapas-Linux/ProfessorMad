


# ######################################
# #   🌟🌟🌟 MAIN PLAYER SCRIPT 🌟🌟🌟 #
# ######################################


class_name Hero
extends CharacterBody2D

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

var screen_size : Vector2
var turn:bool = true
var health:int = 100
const health_max:int = 100


#signal player_stats_changed
signal bomb_hit_me

var eyes_rnd_blink_timer:Timer


# Skeleton2D/Base/Leg_R/Calf_R/Foot_R/RemoteTransform2D
@onready var Foot_R:RemoteTransform2D = get_node("Skeleton2D/Base/Leg_R/Calf_R/Foot_R/RemoteTransform2D")
@onready var Foot_L:RemoteTransform2D = get_node("Skeleton2D/Base/Leg_L/Calf_L/Foot_L/RemoteTransform2D")

@onready var SlopeRayCast:RayCast2D = get_node("RayCast2D")


func _ready():
	gv.fsm = $StateMachine
	$BloodSplash.visible = false
	screen_size = get_viewport_rect().size
	set_process(true)
	set_process_input(true)
	gv.Player = self

	$Body_parts/Head/powieka_P.visible = false
	$Body_parts/Head/powieka_L.visible = false

	if FileAccess.file_exists("user://game.dat") == false:
		gv.save_player_data()
	else:
		gv.load_player_data()	
	
	print("")  
	print("Hero level: " + str(gv.Hero_level)) 
	print("Hero current weapon: " + str(gv.Hero_current_weapon))
	print("Hero money: " + str(gv.Hero_gold))
	print("Hero state: " + gv.fsm.state.name)  
	print("")  

	############################ !!!!!!!!!!!!!!!!	
	gv.Hero_current_weapon = 0
	############################ !!!!!!!!!!!!!!!!

	load_inventory()

	eyes_rnd_blink_timer = Timer.new()
	add_child(eyes_rnd_blink_timer)
	eyes_rnd_blink_timer.wait_time = 5
	eyes_rnd_blink_timer.one_shot = true
	eyes_rnd_blink_timer.connect("timeout", _on_eyes_blink_timer_timeout)
	eyes_rnd_blink_timer.start(randf_range(1.0,10.0))
		
	print("Hero: ready ...") 
	

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
	
	match gv.Hero_current_weapon:
		0: # Empty weapon = none
			if get_node("Body_parts/weapon_spawn/rocket_4").get_child_count() > 0:
				get_node("Body_parts/weapon_spawn/rocket_4").get_child(0).queue_free()
			gv.Hero_weapon = load("res://Scenes/Weapons/Empty/Empty_gun.tscn").instantiate()
			if get_node("Body_parts/weapon_spawn/empty").get_child_count() > 0:
				get_node("Body_parts/weapon_spawn/empty").get_child(0).queue_free()
			get_node("Body_parts/weapon_spawn/empty").add_child(gv.Hero_weapon)
			gv.set_cursor_orange()	
		
		1: # AK-47 
			get_node("Body_parts/weapon_spawn/empty").get_child(0).queue_free()
			gv.Hero_weapon = load("res://Scenes/Weapons/ak_47/AK-47.tscn").instantiate()
			if get_node("Body_parts/weapon_spawn/ak-47").get_child_count() > 0:
				get_node("Body_parts/weapon_spawn/ak-47").get_child(0).queue_free()
			get_node("Body_parts/weapon_spawn/ak-47").add_child(gv.Hero_weapon)
			gv.set_cursor_orange()
			gv.Hero_weapon.transform = get_node("Body_parts/weapon_spawn/ak-47").transform
			gv.Hero_weapon.scale = Vector2(3,3)
		
		2: # RPG-7 Grenade launcher
			get_node("Body_parts/weapon_spawn/ak-47").get_child(0).queue_free()
			gv.Hero_weapon = load("res://Scenes/Weapons/rpg_7/rpg_7.tscn").instantiate()
			if get_node("Body_parts/weapon_spawn/rpg_7").get_child_count() > 0:
				get_node("Body_parts/weapon_spawn/rpg_7").get_child(0).queue_free()
			get_node("Body_parts/weapon_spawn/rpg_7").add_child(gv.Hero_weapon)
			gv.set_cursor_orange()
			gv.Hero_weapon.transform = get_node("Body_parts/weapon_spawn/rpg_7").transform
			gv.Hero_weapon.scale = Vector2(5,7)	

		3: # Home misille rocket launcher
			get_node("Body_parts/weapon_spawn/rpg_7").get_child(0).queue_free()
			gv.Hero_weapon = load("res://Scenes/Weapons/rocket_4/rocket_4_launcher.tscn").instantiate()
			if get_node("Body_parts/weapon_spawn/rocket_4").get_child_count() > 0:
				get_node("Body_parts/weapon_spawn/rocket_4").get_child(0).queue_free()
			get_node("Body_parts/weapon_spawn/rocket_4").add_child(gv.Hero_weapon)
			gv.set_cursor_green()
			gv.Hero_weapon.transform = get_node("Body_parts/weapon_spawn/rocket_4").transform
			gv.Hero_weapon.scale = Vector2(3,3)		

func load_next_weapon():
	print(str(gv.Hero_guns.size()))
	if gv.Hero_guns.size() > gv.Hero_current_weapon:
		gv.Hero_current_weapon += 1
		load_inventory()
		# Hero_guns = {"no": 0, "ak_47": 1, "rpg_7": 2 }
	if gv.Hero_guns.size() == gv.Hero_current_weapon:
		gv.Hero_current_weapon = 0
		load_inventory()

	gv.Hero_global_position = global_position
	gv.Hero_local_position = position
	if global_position.x < -1500:
		global_position.x = -500
		gv.fsm.transition_to("Idle")
	
	if is_on_wall():
		gv.Hero_is_on_wall = true
	else:
		gv.Hero_is_on_wall = false

func _process(_delta: float) -> void:
	pass
	
func _on_gun_2_fire() -> void:
	print("Hero: me shooting")
		
func _on_idle_turn(value):
	turn = value

func hit():
	print("Hero: enemies hit me by bullet!") 
	if health > 0:
		health -= 10
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	gv.Hero_on_screen = false

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	gv.Hero_on_screen = true

func _on_left_area_2d_area_entered(area:Area2D) -> void:
	if area.name == "Bomb2":
		health -= 25
		gv.fsm.transition_to("Shockwave", {back_area = true}) 	
		print("Left PlayerArea2D hit by: " + area.name) 

func _on_right_area_2d_area_entered(area:Area2D) -> void:
	if area.name == "Bomb2":
		health -= 25
		gv.fsm.transition_to("Shockwave", {front_area = true}) 
		print("Right PlayerArea2D hit by: " + area.name)

func _on_left_area_2d_body_entered(body:Node2D) -> void:
	print("Left PlayerArea enter body: " + body.name) 


func _on_right_area_2d_body_entered(body:Node2D) -> void:
	print("Right PlayerArea enter body: " + body.name) 


func bomb_explode():
	if health > 0:
		health -= 25	
	print("Hero: enemies hit me by drone big bomb!")
	gv.fsm.transition_to("Hit_bomb")












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
































