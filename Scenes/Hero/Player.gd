


# |#################|>
# |# PLAYER.SCRIPT #|>>>
# |#################|>


class_name Hero
extends CharacterBody2D

# Horizontal speed in pixels per second.
@export var speed := 250.0

# run speed
@export var speed_run := 500.0

# run jump impulse
@export var jump_impulse_run := 1700.0

# Vertical acceleration in pixel per second squared.
@export var gravity := 2000.0

# Vertical speed applied when jumping.
@export var jump_impulse := 1200.0

var screen_size : Vector2
var turn:bool = true
var health:int = 100
const health_max:int = 100


signal player_stats_changed
signal bomb_hit_me

# node.reparent(new_parent)

func _ready():
	gv.fsm = $StateMachine
	$BloodSplash.visible = false
	screen_size = get_viewport_rect().size
	set_process(true)
	set_process_input(true)
	gv.Player = self
	

	if FileAccess.file_exists("user://game.dat") == false:
		gv.save_player_data()
	else:
		gv.load_player_data()	

	
	print("")  
	print("Hero level: " + str(gv.Hero_level)) 
	print("Hero current weapon: " + str(gv.Hero_current_weapon))
	print("Hero money: " + str(gv.Hero_gold)) 
	print("")  

	############################ !!!!!!!!!!!!!!!!	
	gv.Hero_current_weapon = 3

	load_inventory()
	
	emit_signal("player_stats_changed", self)
	print("Hero: ready ...") 
	


func load_inventory():
	match gv.Hero_current_weapon:
		0:
			if get_node("Torso/arm_r").get_child_count() > 1:
				get_node("Torso/arm_r").get_child(1).queue_free()
		1:
			gv.Hero_weapon = load("res://Scenes/Weapons/ak_47/AK-47.tscn").instantiate()
			if get_node("Torso/arm_r").get_child_count() > 1:
				get_node("Torso/arm_r").get_child(1).queue_free()
			get_node("Torso/arm_r").add_child(gv.Hero_weapon)
			gv.set_cursor_orange()
			gv.Hero_weapon.transform = get_node("Torso/arm_r/weapon_spawn").transform
			gv.Hero_weapon.scale = Vector2(3.2,3.2)
		2:
			gv.Hero_weapon = load("res://Scenes/Weapons/rpg_7/rpg_7.tscn").instantiate()
			if get_node("Torso/arm_r").get_child_count() > 1:
				get_node("Torso/arm_r").get_child(1).queue_free()
			get_node("Torso/arm_r").add_child(gv.Hero_weapon)
			gv.set_cursor_orange()
			gv.Hero_weapon.transform = get_node("Torso/arm_r/weapon_spawn").transform
			gv.Hero_weapon.scale = Vector2(5,7)	

		3:
			gv.Hero_weapon = load("res://Scenes/Weapons/rocket_4/rocket_4_launcher.tscn").instantiate()
			if get_node("Torso/arm_r").get_child_count() > 1:
				get_node("Torso/arm_r").get_child(1).queue_free()
			get_node("Torso/arm_r").add_child(gv.Hero_weapon)
			gv.set_cursor_green()
			gv.Hero_weapon.transform = get_node("Torso/arm_r/weapon_spawn").transform
			gv.Hero_weapon.scale = Vector2(3,3)		


func load_next_weapon():
	print(str(gv.Hero_guns.size()))
	if gv.Hero_guns.size() > gv.Hero_current_weapon:
		gv.Hero_current_weapon += 1
		load_inventory()
		# Hero_guns = {"no": 0, "ak_47": 1, "rpg_7": 2}
	if gv.Hero_guns.size() == gv.Hero_current_weapon:
		gv.Hero_current_weapon = 0
		load_inventory()



func _physics_process(_delta):
	gv.Hero_global_position = global_position
	gv.Hero_local_position = position
	if position.x < -50:
		position.x = 0
	
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
	

func _on_player_area_area_entered(area: Area2D) -> void:
	if(area.name == "Bomb2"):
		health -= 25
	print("PlayerArea hit by: " + area.name) 

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("PlayerArea enter body: " + body.name) 

func bomb_explode():
	if health > 0:
		health -= 25	
	print("Hero: enemies hit me by drone big bomb!")

	#ShakeScreen.shake(60,0.5)
	
	gv.fsm.transition_to("Hit_bomb")













# #################
# # GARBAGE       #
# #################

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


















