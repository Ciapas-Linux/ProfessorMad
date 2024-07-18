extends RigidBody2D

##############################################
# GDscript:									 #
# Fiat125p rigid body version				 #
# Player car converted into combat           #
#											 #	
##############################################



@export var hit_count:int = 12
@export var speed:float = 60000


@onready var tween: Tween

var local_cursor_position:Vector2
var player_distance:float

const MOVE_RIGHT: int = 0
const MOVE_LEFT: int = 1
const STOP: int = 2

var mouse_enter:bool = false
var current_state : int = STOP
	
@onready var sounds:Array = [load("res://Assets/Sounds/pisk_opon1.wav"),
  	load("res://Assets/Sounds/pisk_opon2.wav"),
  	load("res://Assets/Sounds/pisk_opon3.wav")]
	
var Player_level:int = 1	
var Player_health:int = 100
const Player_health_max:int = 100
var Player_tilt:int = 0
var Player_gold:int = 0
var Player_direction:Vector2 = Vector2.RIGHT
var Player_on_screen:bool = true	
var Player_state:String = "Drive"
var Player_up_down:int = 0 # 0:flat 1:up 2:down
var Player_weapon:Sprite2D
var Player_guns = {"no": 0, "ak_47": 1, "rpg_7": 2, "rocket_4": 3}
var Player_current_weapon:int = Player_guns["ak_47"]


var wheels:Array[RigidBody2D] = []

@onready var anim_player : AnimationPlayer = get_node("AnimationPlayer")
	
func _ready() -> void:
	gv.Player = self
	self.input_pickable = true
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	$BigExplosion.visible = false
	wheels.append($WheelHolder.get_node("Wheel"))
	wheels.append($WheelHolder2.get_node("Wheel")) 
	$smoke_particles.emitting = true
	get_node("snd_engine").play()
	get_node("snd_engine").set_volume_db(10)
	$Driver/AnimationPlayer.play("head_rotate")
	#Player_weapon = load("res://Scenes/Weapons/Empty/Empty_gun.tscn").instantiate()
	
	############################ !!!!!!!!!!!!!!!!	
	Player_current_weapon = 0
	############################ !!!!!!!!!!!!!!!!

	load_inventory()

	print("Player car Fiat125p rigid start x: " + str(global_position.x))

	# turn_right()
	# flip_v(true)
		

func _process(_delta: float) -> void:
	pass	

func _physics_process(_delta) -> void:
	match current_state:
		STOP:
			_process_on_state_stop(_delta)
		MOVE_RIGHT:
			_process_on_state_move_right(_delta)
		MOVE_LEFT:
			_process_on_state_move_left(_delta)

func _unhandled_input(event):
	if gv.Player.Player_current_weapon == gv.Player.Player_guns["rocket_4"]:
		if event.is_action_pressed("mouse_left_click") && mouse_enter: 
			# do here whatever should happen when you click on that node:
			gv.mouse_enter_node = self
			print(self.name + ": left mouse click me!")
			$snd_click.play() 
			get_viewport().set_input_as_handled()
			gv.set_cursor_red()
			var space_state = get_world_2d().direct_space_state
			var params = PhysicsPointQueryParameters2D.new()
			params.position = get_global_mouse_position()
			var out = space_state.intersect_point(params)
			for node in out:
				print(node.collider.name)

func _process_on_state_stop(delta) -> void:
	if Input.is_action_pressed("ui_right"):
	 	#$snd_click.play()
		for wheel in wheels:
			wheel.apply_torque_impulse(speed * delta * 60)
	if Input.is_action_pressed("ui_left"):
	 	#$snd_click.play()
		for wheel in wheels:
			wheel.apply_torque_impulse(-speed * delta * 60)

	# if gv.Player_current_weapon != 0:
	# GO --> Switch weapon	
	if Input.is_action_just_pressed("Weapon"):
			get_node("snd_switch_weapon").play()
			load_next_weapon()
			print("Player: switch weapon")		


func _process_on_state_move_right(_delta: float) -> void:
	#velocity.x = speed
	#velocity.y += gravity * delta
	#constant_force = Vector2.RIGHT
	#constant_torque = 12.0
	#apply_central_impulse(Vector2(0, -10))
	#apply_torque_impulse(-100)
	player_distance = global_position.distance_to(gv.Hero_global_position)
	#move_and_slide()
	

func _process_on_state_move_left(_delta: float) -> void:
	#velocity.x = -speed
	#velocity.y += gravity * delta
	player_distance = global_position.distance_to(gv.Hero_global_position)
	#move_and_slide()				

func _integrate_forces(_state):
	pass
	#add_constant_force( Vector2(1000, 0), Vector2(0, 0) )

	# if Input.is_action_just_pressed("ui_up"):
	# 	$snd_click.play()


		#state.apply_force(thrust.rotated(rotation))
		#apply_impulse(Vector2(0, 0),Vector2(100,0))
		#apply_force(-transform.y, transform.origin + Vector2.DOWN * 0.5)
		#apply_central_impulse(Vector2(100, 0))
		
		#set_linear_velocity(Vector2(1500,0))

	# else:
	# 	state.apply_force(Vector2())
	# var rotation_direction = 0
	# if Input.is_action_pressed("ui_right"):
	# 	rotation_direction += 1
	# if Input.is_action_pressed("ui_left"):
	# 	rotation_direction -= 1
	# state.apply_torque(rotation_direction * torque)

func load_inventory():  # Body_parts/Arm_R/Hand_R/weapon_spawn
						# Torso/arm_r/weapon_spawn
						# Torso/arm_r
	
	#var spawn_node_path:String = "Body_parts/weapon_spawn"
	#var marker_node_path:String = "Body_parts/weapon_spawn"
	
	match Player_current_weapon:
		0: # Empty weapon = none
			if get_node("weapon_spawn/rocket_4").get_child_count() > 0:
				get_node("weapon_spawn/rocket_4").get_child(0).queue_free()
			Player_weapon = load("res://Scenes/Weapons/Empty/Empty_gun.tscn").instantiate()
			if get_node("weapon_spawn/empty").get_child_count() > 0:
				get_node("weapon_spawn/empty").get_child(0).queue_free()
			get_node("weapon_spawn/empty").add_child(Player_weapon)
			gv.set_cursor_orange()	
		
		1: # AK-47 
			get_node("weapon_spawn/empty").get_child(0).queue_free()
			Player_weapon = load("res://Scenes/Weapons/ak_47/AK-47.tscn").instantiate()
			if get_node("weapon_spawn/ak-47").get_child_count() > 0:
				get_node("weapon_spawn/ak-47").get_child(0).queue_free()
			get_node("weapon_spawn/ak-47").add_child(Player_weapon)
			gv.set_cursor_orange()
			Player_weapon.transform = get_node("weapon_spawn/ak-47").transform
			Player_weapon.scale = Vector2(3.0,3.0)
		
		2: # RPG-7 Grenade launcher
			get_node("weapon_spawn/ak-47").get_child(0).queue_free()
			Player_weapon = load("res://Scenes/Weapons/rpg_7/rpg_7.tscn").instantiate()
			if get_node("weapon_spawn/rpg_7").get_child_count() > 0:
				get_node("weapon_spawn/rpg_7").get_child(0).queue_free()
			get_node("weapon_spawn/rpg_7").add_child(Player_weapon)
			gv.set_cursor_orange()
			Player_weapon.transform = get_node("weapon_spawn/rpg_7").transform
			Player_weapon.scale = Vector2(5,7)	

		3: # Home misille rocket launcher
			get_node("weapon_spawn/rpg_7").get_child(0).queue_free()
			Player_weapon = load("res://Scenes/Weapons/rocket_4/rocket_4_launcher.tscn").instantiate()
			if get_node("weapon_spawn/rocket_4").get_child_count() > 0:
				get_node("weapon_spawn/rocket_4").get_child(0).queue_free()
			get_node("weapon_spawn/rocket_4").add_child(Player_weapon)
			gv.set_cursor_green()
			Player_weapon.transform = get_node("weapon_spawn/rocket_4").transform
			Player_weapon.scale = Vector2(3,3)

	print("Player car inventory loaded")
				

func load_next_weapon():
	print(str(Player_guns.size()))
	if Player_guns.size() > Player_current_weapon:
		Player_current_weapon += 1
		load_inventory()
		# Player_guns = {"no": 0, "ak_47": 1, "rpg_7": 2 }
	if Player_guns.size() == Player_current_weapon:
		Player_current_weapon = 0
		load_inventory()


func is_on_floor():
	return true

func is_on_wall():
	return true

func get_velocity():
	return get_linear_velocity()	

func _on_mouse_entered() -> void:
	mouse_enter = true

func _on_mouse_exited() -> void:
	mouse_enter = false


func _tween():
	tween = get_tree().create_tween()
	#tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR) # or TRANS_LINEAR,TRANS_QUINT,TRANS_CUBIC,TRANS_BACK,TRANS_SINE
	tween.set_parallel(true)
	$object_spr.visible = false

	for wheel in wheels:
			wheel.visible = false

	var _sign: int = 0		 

	for _node in $body_parts.get_children():
		_node.visible = true
		#print("Fiat125p Rigid: " + _node.name)

		_sign = randi_range(0,1)

		if _sign == 0:
			tween.tween_property(_node, "global_position", Vector2(global_position.x - randf_range(-270, 570), global_position.y - randf_range(270, 770)), 0.9)
		elif _sign == 1:
			tween.tween_property(_node, "global_position", Vector2(global_position.x + randf_range(-170, 570), global_position.y - randf_range(270, 720)), 0.9)
		
		tween.tween_property(_node, "rotation", randf_range(-3.5, 3.5), 1.0)
		tween.tween_property(_node, "self_modulate", Color(1, 1, 1, 0), 1.0)
				
	# DRIVER SPRITE:		
	tween.tween_property($Driver, "global_position", Vector2(global_position.x, global_position.y - randf_range(150, 670)), 0.9)
	tween.tween_property($Driver, "rotation", randf_range(-3.5, 3.5), 1.0)
	tween.tween_property($Driver, "self_modulate", Color(1, 1, 1, 0), 1.0)

	

func rpg_hit():
	$CollisionPolygon2D.set_deferred("disabled", true)
	#$MaluchArea2D/CollisionPolygon2D.set_deferred("disabled", true)
	$BigExplosion.visible = true
	$BigExplosion.explode()
	$smoke_particles.emitting = false
	$smoke_particles.visible = false
	_tween()
	await get_tree().create_timer(0.3).timeout
	$Bullet_holes.vanish()
	current_state = STOP
	get_node("snd_engine").stop()
	$snd_player.stop()
	


func bomb_explode():
	$CollisionPolygon2D.set_deferred("disabled", true)
	#$MaluchArea2D/CollisionPolygon2D.set_deferred("disabled", true)
	$BigExplosion.visible = true
	$BigExplosion.explode()
	$smoke_particles.emitting = false
	$smoke_particles.visible = false
	await get_tree().create_timer(0.3).timeout
	$Bullet_holes.vanish()
	current_state = STOP
	get_node("snd_engine").stop()
	$snd_player.stop()
	_tween()

func hit()-> void:
	if hit_count > 0:
		print("Player Fiat125p: got hit " + "hits: " + str(hit_count))
		$Bullet_holes.hit()
		hit_count -= 1
		
		if hit_count == 0:
			$CollisionPolygon2D.set_deferred("disabled", true)
			#$MaluchArea2D/CollisionPolygon2D.set_deferred("disabled", true)
			$BigExplosion.explode()
			$BigExplosion.visible = true
			$smoke_particles.emitting = false
			$smoke_particles.visible = false
			await get_tree().create_timer(0.3).timeout
			$Bullet_holes.vanish()
			current_state = STOP
			get_node("snd_engine").stop()
			$snd_player.stop()
			_tween()
			gv.Cam1.ScreenShake(30,0.5)
			#queue_free()	

func flip_h(flip:bool):
	var x_axis = global_transform.x
	global_transform.x.x = (-1 if flip else 1) * abs(x_axis.x)

func flip_v(flip:bool):
	var y_axis = global_transform.y
	global_transform.y.y = (-1 if flip else 1) * abs(y_axis.y)	

func flip_child():
	for child in get_children():
		if child.get("scale") != null:
			child.scale.x = -child.scale.x
	
func turn_left() -> void:
	$body_parts.scale.x = scale.y * 1
	$CollisionPolygon2D.scale.x = scale.y * 1
	$kolo_l_CollisionPolygon2D.scale.x = scale.y * 1
	$kolo_p_CollisionPolygon2D.scale.x = scale.y * 1
	$smoke_particles.gravity = Vector2(-100.0, 2.0)
	current_state = MOVE_LEFT


func turn_right() -> void:
	$body_parts.scale.x = $body_parts.scale.y * -1
	$object_spr.scale.x = $object_spr.scale.y * -1
	$Driver.scale.x = $Driver.scale.y * 1
	$CollisionPolygon2D.scale.x = $CollisionPolygon2D.scale.y * -1
	#$kolo_l_CollisionPolygon2D.scale.x = $kolo_l_CollisionPolygon2D.scale.y * -1
	#$kolo_p_CollisionPolygon2D.scale.x = $kolo_p_CollisionPolygon2D.scale.y * -1
	$smoke_particles.position.x -= 500
	#apply_scale(Vector2(-1,1))
	#transform.x.x = transform.y.y * -1
	$smoke_particles.gravity = Vector2(100.0, 2.0)
	#$smoke_particles.amount = 20
	#current_state = MOVE_RIGHT	

func stop_drive() -> void:
		current_state = STOP
		$body_parts/Kolo_l/AnimationPlayer.stop(true)
		$body_parts/Kolo_p/AnimationPlayer.stop(true)
		$body_parts/Driver/AnimationPlayer.play("RESET")
		#$Boss/AnimationPlayer.play("RESET")
		get_node("snd_engine").stop()

func start_drive(car_direction:int) -> void:
	if $smoke_particles.emitting == false:
			$smoke_particles.emitting = true
	
	if $body_parts/Kolo_l/AnimationPlayer.is_playing() == false:
		$body_parts/Kolo_l/AnimationPlayer.play("rotate",-1,speed*0.001,false)
			
	if $body_parts/Kolo_p/AnimationPlayer.is_playing() == false:
		$body_parts/Kolo_p/AnimationPlayer.play("rotate",-1,speed*0.001,false)
	
	if $body_parts/Driver/AnimationPlayer.is_playing() == false:
		$body_parts/Driver/AnimationPlayer.play("head_rotate")
		
	#if $Boss/AnimationPlayer.is_playing() == false:
		#$Boss/AnimationPlayer.play("rotate")	
		
	if get_node("snd_engine").playing != true:
			get_node("snd_engine").play()

	match car_direction:
		MOVE_RIGHT:
			turn_right()
				
		MOVE_LEFT:
			turn_left()	

	current_state = car_direction		

func start_talk():
	if $Driver.is_playing() == false:
		$Driver.play("talk")


func stop_talk():
	$Driver.stop()


func _on_timer_timeout() -> void:
	if current_state == STOP:
		return
	speed = randf_range(10.0,800.0)
	if speed < 50 or speed > 300:
		$snd_player.stream = sounds[randi() % len(sounds)]
		if $snd_player.playing != true:
			$snd_player.play()
	#$body_parts/Kolo_l/AnimationPlayer.play("rotate",-1,speed*0.001,false)
	#$body_parts/Kolo_p/AnimationPlayer.play("rotate",-1,speed*0.001,false)
	

func _on_front_contact_area_entered(_area:Area2D) -> void:
	# print("Fiat125p, front contact area: " + area.name)
	# $snd_hit.play()
	pass
	
func _on_front_contact_body_entered(body:Node2D) -> void:
	if body.name != "Fiat125p_rigid" and body.name != "Wheel":
		if body.get_parent().has_method("hit"):
			body.get_parent().hit()
		$snd_hit2.play()
		print("Fiat125p, front contact body: " + body.name)


func _on_back_contact_area_entered(_area:Area2D) -> void:
	# print("Fiat125p, back contact area: " + area.name)
	# $snd_hit.play()
	pass

func _on_back_contact_body_entered(body:Node2D) -> void:
	if body.name != "Fiat125p_rigid":	
		$snd_hit.play()
		print("Fiat125p, back contact body: " + body.name)


func _on_floor_contact_area_entered(_area:Area2D) -> void:
	# print("Fiat125p, floor contact area: " + area.name)
	# $snd_touch_ground.play()
	pass

func _on_floor_contact_body_entered(body:Node2D) -> void:
	if body.name != "Fiat125p_rigid":
		$snd_touch_ground.play()
		print("Fiat125p, floor contact body: " + body.name)


func _on_top_contact_body_entered(body:Node2D) -> void:
	if body.name != "Fiat125p_rigid":
		$snd_touch_ground.play()
		print("Fiat125p, top contact body: " + body.name)


func _on_big_explosion_finished() -> void:
	for wheel in wheels:
			wheel.queue_free()
	queue_free() 


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	Player_on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	Player_on_screen = false
