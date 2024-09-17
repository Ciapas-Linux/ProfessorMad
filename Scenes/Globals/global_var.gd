extends Node


var Game_pause:bool = false
var current_scene = null

# GLOBAL RESOURCES
#var Bullet_hit1_texure:CompressedTexture2D = preload("res://Assets/Particles/bullet-holes/bullet-hole1-sm.png")


# GLOBAL ASSETS:
@onready var Bullet_hit_textures:Array[CompressedTexture2D] = [
	preload("res://Assets/Particles/bullet-holes/bullet-hole1-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet_hole_64.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole2-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole3-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole4-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole5-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole6-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole7-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole8-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole9-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole10-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole11-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole12-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole13-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole14-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole15-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole16-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole17-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole18-sm.png"),
	preload("res://Assets/Particles/bullet-holes/bullet-hole19-sm.png") ]

var cursor_green = preload("res://Assets/Weapons/crosshair/reticle_green.png")
var cursor_green_2 = preload("res://Assets/Weapons/crosshair/crosshair2.png")
var cursor_orange = preload("res://Assets/Weapons/crosshair/reticle.png")
var cursor_red = preload("res://Assets/Weapons/crosshair/reticle_red.png")

# @onready var Weapons:Array[Resource] = [load("res://Scenes/Weapons/Empty/Empty_gun.tscn"),
# 	load("res://Scenes/Weapons/ak_47/AK-47.tscn"),
# 	load("res://Scenes/Weapons/rpg_7/rpg_7.tscn"),
# 	load("res://Scenes/Weapons/rocket_4/rocket_4_launcher.tscn"),
# 	load("res://Scenes/Weapons/tt_gun/tt_gun.tscn"),
# 	load("res://Scenes/Weapons/Grenades/F1_handle.tscn")]


# var snd_sfx1:Resource = preload("res://Assets/Sounds/Sfx/object.wav")


# PLAYER:
var Player
# Player global signals:
signal player_bullet_ready
#signal s_mouse_enter_node(node :Node2D)
var mouse_enter_node:Node2D

# GUI signals:
# var pop_up_2D:Resource = preload("res://Scenes/UI/PopUp_2D.tscn")
# signal popup_2D_dialog


# ENEMY FIRST BOSS WREDNY RYSIEK
@onready var EnemyRysiek:Rysiek


# 3D experimentos
@onready var Player3d:Player3D

# 2.5D experimentos
@onready var Player25d:Player25D


# CAMERA
var Cam1:Camera2D

# system info
var platform:String
var SWidth:int = 0
var SHeight:int = 0

# func point_cast(point : Vector2, filter : Array = [], mask : int = 0xFFFFFFFF, count : int = 32) -> Array:
# 	var hits := get_world_2d().direct_space_state.intersect_point(point, count, filter, mask, true, true)
# 	for i in range(hits.size()): hits[i] = hits[i].collider as CollisionObject2D
# 	return hits

# func nodes_sorted_by_scene_order(nodes : Array) -> Array:
# 	nodes = nodes.duplicate()
# 	nodes.sort_custom(self, "_tree_order_descending")
# 	return nodes


func load_next_weapon():
	Player.Player_current_weapon += 1
	if Player.Player_current_weapon > 5:
		Player.Player_current_weapon = 0
	load_inventory(Player.Player_current_weapon)		

func load_inventory(target_inventory: int):  
	match target_inventory:
		0: # Empty weapon = none
			if Player.get_node("weapon_spawn/f1_grenade").get_child_count() > 0:
				Player.get_node("weapon_spawn/f1_grenade").get_child(0).queue_free()
			Player.Player_weapon = load("res://Scenes/Weapons/Empty/Empty_gun.tscn").instantiate()
			if Player.get_node("weapon_spawn/empty").get_child_count() > 0:
				Player.get_node("weapon_spawn/empty").get_child(0).queue_free()
			Player.get_node("weapon_spawn/empty").add_child(Player.Player_weapon)
			set_cursor_orange()	
		
		1: # AK-47 
			Player.get_node("weapon_spawn/empty").get_child(0).queue_free()
			Player.Player_weapon = load("res://Scenes/Weapons/ak_47/AK-47.tscn").instantiate()
			if Player.get_node("weapon_spawn/ak-47").get_child_count() > 0:
				Player.get_node("weapon_spawn/ak-47").get_child(0).queue_free()
			Player.get_node("weapon_spawn/ak-47").add_child(Player.Player_weapon)
			set_cursor_orange()
			Player.Player_weapon.transform = Player.get_node("weapon_spawn/ak-47").transform
			Player.Player_weapon.scale = Vector2(3,3)
		
		2: # RPG-7 Grenade launcher
			Player.get_node("weapon_spawn/ak-47").get_child(0).queue_free()
			Player.Player_weapon = load("res://Scenes/Weapons/rpg_7/rpg_7.tscn").instantiate()
			if Player.get_node("weapon_spawn/rpg_7").get_child_count() > 0:
				Player.get_node("weapon_spawn/rpg_7").get_child(0).queue_free()
			Player.get_node("weapon_spawn/rpg_7").add_child(Player.Player_weapon)
			set_cursor_orange()
			Player.Player_weapon.transform = Player.get_node("weapon_spawn/rpg_7").transform
			Player.Player_weapon.scale = Vector2(5,7)	

		3: # Home misille rocket launcher
			Player.get_node("weapon_spawn/rpg_7").get_child(0).queue_free()
			Player.Player_weapon = load("res://Scenes/Weapons/rocket_4/rocket_4_launcher.tscn").instantiate()
			if Player.get_node("weapon_spawn/rocket_4").get_child_count() > 0:
				Player.get_node("weapon_spawn/rocket_4").get_child(0).queue_free()
			Player.get_node("weapon_spawn/rocket_4").add_child(Player.Player_weapon)
			set_cursor_green()
			Player.Player_weapon.transform = Player.get_node("weapon_spawn/rocket_4").transform
			Player.Player_weapon.scale = Vector2(3,3)

		4: # TT tokarev hand gun
			Player.get_node("weapon_spawn/rocket_4").get_child(0).queue_free()
			Player.Player_weapon = load("res://Scenes/Weapons/tt_gun/tt_gun.tscn").instantiate()
			if Player.get_node("weapon_spawn/tt_gun").get_child_count() > 0:
				Player.get_node("weapon_spawn/tt_gun").get_child(0).queue_free()
			Player.get_node("weapon_spawn/tt_gun").add_child(Player.Player_weapon)
			set_cursor_orange()
			Player.Player_weapon.transform = Player.get_node("weapon_spawn/tt_gun").transform
			Player.Player_weapon.scale = Vector2(2,2)			

		5: # F1 hand grenade:
			Player.get_node("weapon_spawn/tt_gun").get_child(0).queue_free()
			Player.Player_weapon = load("res://Scenes/Weapons/Grenades/F1_handle.tscn").instantiate()
			if Player.get_node("weapon_spawn/f1_grenade").get_child_count() > 0:
				Player.get_node("weapon_spawn/f1_grenade").get_child(0).queue_free()
			Player.get_node("weapon_spawn/f1_grenade").add_child(Player.Player_weapon)
			set_cursor_orange()
			Player.Player_weapon.transform = Player.get_node("weapon_spawn/f1_grenade").transform
			Player.Player_weapon.scale = Vector2(1,1)

	print(Player.name + ": inventory loaded: " + str(Player.Player_current_weapon))
	


func select_top_node(target_node: Area2D) -> Area2D:
	var top_piece: Area2D
	var top_z:int = -1
	var space_state:PhysicsDirectSpaceState2D = target_node.get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = target_node.get_global_mouse_position()
	var out = space_state.intersect_point(params)
	for node in out:
		print(node.collider.name)
	for node in out:
		if node.collider.z_index > top_z:
			top_piece = node.collider
			top_z = node.collider.z_index
	return top_piece

func get_closest_enemy(node:Node2D):
	var enemies = get_tree().get_nodes_in_group('Enemies')
	if enemies.empty(): return null
	var distances = []
	for enemy in enemies:
		var distance = node.global_position.distance_squared_to(enemy.global_position)
		distances.append(distance)
	var min_distance = distances.min()
	var min_index = distances.find(min_distance)
	var closest_enemy = enemies[min_index]
	return closest_enemy

func get_closest_enemy2(node:Node2D):
	var enemies = get_tree().get_nodes_in_group('Enemies')
	var closest_enemy = null
	var min_distance = INF

	for enemy in enemies:
		var distance = node.global_position.distance_squared_to(enemy.global_position)
		if distance < min_distance:
			min_distance = distance
			closest_enemy = enemy
	return closest_enemy

func set_cursor_green():
	Input.set_custom_mouse_cursor(cursor_green_2, Input.CURSOR_ARROW, Vector2(24, 24))
	
func set_cursor_orange() -> void:
	Input.set_custom_mouse_cursor(cursor_orange, Input.CURSOR_ARROW, Vector2(24, 24))

func set_cursor_red() -> void:
	Input.set_custom_mouse_cursor(cursor_red, Input.CURSOR_ARROW, Vector2(24, 24))



func save_player_data() -> void:
	var file:FileAccess = FileAccess.open("user://game.dat", FileAccess.WRITE)
	file.store_32(Player.Player_level)
	file.store_32(Player.Player_current_weapon)
	file.store_32(Player.Player_gold)
	
	

func load_player_data() -> void:
	var file:FileAccess = FileAccess.open("user://game.dat", FileAccess.READ)
	Player.Player_level = file.get_32()
	Player.Player_current_weapon = file.get_32()
	Player.Player_gold = file.get_32()
	#print("Level: " + str(file.get_32()))
	#print("Weapon: " + str(file.get_32()))
	#print("Gold: " + str(file.get_32()))


func remap_range(value, InputA, InputB, OutputA, OutputB):
	return(value - InputA) / (InputB - InputA) * (OutputB - OutputA) + OutputA


func _ready():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	platform = OS.get_name()
	#var root2 = get_node("/root")
	#print(root2.get_rect())		
	var platform_name:String = "Platform: "
	match OS.get_name():
		"Windows", "UWP":
			print(platform_name + "Windows")
		"macOS":
			print(platform_name +"macOS")
		"Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			print(platform_name + "Linux/BSD")
		"Android":
			print(platform_name + "Android")
		"iOS":
			print(platform_name + "iOS")
		"Web":
			print(platform_name + "Web")
			
	SWidth = ProjectSettings.get_setting("display/window/size/viewport_width")
	SHeight = ProjectSettings.get_setting("display/window/size/viewport_height")
	
	print("Screen width: " + str(SWidth) + "   " + "Screen height :" + str(SHeight))

	print("Get Cam1 2D reference if exist...")		
	Cam1 = get_node("/root/Stage/Camera2DPro")
	
		
	print("Stage ready ...")	

func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s:Resource = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene


# func _one_shot_timer_example():
# 	print("start")
# 	await get_tree().create_timer(1.0).timeout
# 	print("end")
	




#var project_size = Vector2D(
#		ProjectSettings.get_setting("display/window/size/width"),
#		ProjectSettings.get_setting("display/window/size/height")
#	)
#var current_scale = -1

# Scene switch usage
#func _on_Button_pressed():
#	gv.goto_scene("res://Scene2.tscn")
