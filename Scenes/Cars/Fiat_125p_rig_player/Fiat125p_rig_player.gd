extends RigidBody2D

##############################################
# GDscript:									 #
# Fiat125p rigid body version				 #
# Player car converted into combat           #
#											 #	
##############################################


# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

const rpm_idle: float = 400
var rpm_power: float = rpm_idle
@export var baseline_rpm := 800.0
@export var pitch_scale := 1700.0
@export_range(0.0, 20000.0, 0.1, "or_greater") var rpm_limit := 5000.0
@export_range(0.0, 2000.0, 0.1, "or_greater") var idle_rpm := 800.0
@export var drive_loop : AudioStreamPlayer
var rpm_reduction_timer: Timer
var rpm_reduction:bool = false
var speed_kmh: int = 0
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@export var hit_count: int = 30
@export var torqe_impulse: float = 60000
@export var max_velocity: float = 2000




@onready var tween: Tween

var local_cursor_position: Vector2
var player_distance: float


var mouse_enter: bool = false

@onready var FloorRayCast_R: RayCast2D = get_node("Right_ground_RayCast2D")
@onready var FloorRayCast_L: RayCast2D = get_node("Left_ground_RayCast2D")
var on_floor_r: bool = false
var on_floor_l: bool = false

@onready var sounds: Array = [load("res://Assets/Sounds/Vehicles/pisk_opon1.wav"),
  	load("res://Assets/Sounds/Vehicles/pisk_opon2.wav"),
  	load("res://Assets/Sounds/Vehicles/pisk_opon3.wav")]
	
var Player_level: int = 1
var Player_health: int = 100
const Player_health_max: int = 100
var Player_tilt: int = 0
var Player_gold: int = 0
var Player_direction: Vector2 = Vector2.RIGHT
var Player_on_screen: bool = true
var Player_state: String = "Drive"
var Player_up_down: int = 0 # 0:flat 1:up 2:down
var Player_weapon: Sprite2D
var Player_guns = {"no": 0, "ak_47": 1, "rpg_7": 2, "rocket_4": 3, "tt_gun": 4}
var Player_current_weapon: int = Player_guns["ak_47"]

var shock_vave_timer: Timer
var shock_vave_impulse: bool = false
var shock_vave_direction: Vector2 = Vector2.RIGHT
var shock_vave_power: Vector2 = Vector2(0, 0)

var wheels: Array[RigidBody2D] = []

@onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
	
var eyes_rnd_blink_timer: Timer

func _ready() -> void:
	gv.Player = self
	self.input_pickable = true
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	$BigExplosion.visible = false
	$Driver/Eye_l.visible = false
	$Driver/Eye_r.visible = false
	wheels.append($WheelHolder.get_node("Wheel"))
	wheels.append($WheelHolder2.get_node("Wheel"))
	$smoke_particles.emitting = true
	
	#get_node("snd_engine").play()
	#get_node("snd_engine").set_volume_db(10)
	
	# Engine sound:
	#var original_volume := drive_loop.volume_db
	drive_loop.volume_db = linear_to_db(1.0)
	drive_loop.play()
	#await get_tree().process_frame
	#drive_loop.volume_db = original_volume
	
	
	$Driver/AnimationPlayer.play("head_rotate")
	
	############################ !!!!!!!!!!!!!!!!	
	Player_current_weapon = 0
	############################ !!!!!!!!!!!!!!!!



	gv.load_inventory()


	 

	# rpm_reduction_timer = Timer.new()
	# add_child(rpm_reduction_timer)
	# rpm_reduction_timer.wait_time = 0.5
	# rpm_reduction_timer.one_shot = true
	# rpm_reduction_timer.connect("timeout", rpm_reduction_timer_timeout)


	shock_vave_timer = Timer.new()
	add_child(shock_vave_timer)
	shock_vave_timer.wait_time = 0.15
	shock_vave_timer.one_shot = true
	shock_vave_timer.connect("timeout", shock_vave_timer_timeout)

	eyes_rnd_blink_timer = Timer.new()
	add_child(eyes_rnd_blink_timer)
	eyes_rnd_blink_timer.wait_time = 5
	eyes_rnd_blink_timer.one_shot = true
	eyes_rnd_blink_timer.connect("timeout", _on_eyes_blink_timer_timeout)
	eyes_rnd_blink_timer.start(randf_range(1.0, 10.0))

	print("Node ready:" + self.name)
	print(self.name + " start x: " + str(global_position.x))

	# turn_right()
	# flip_v(true)

func _on_eyes_blink_timer_timeout():
	if $Driver/Eye_r.visible == true:
		open_eyes()
		eyes_rnd_blink_timer.start(randf_range(2, 10))
	else:
		close_eyes()
		eyes_rnd_blink_timer.start(randf_range(0.3, 2))

func open_eyes():
	open_left_eye()
	open_right_eye()

func close_eyes():
	close_left_eye()
	close_right_eye()

func close_left_eye():
	$Driver/Eye_l.visible = true

func close_right_eye():
	$Driver/Eye_r.visible = true

func open_left_eye():
	$Driver/Eye_l.visible = false

func open_right_eye():
	$Driver/Eye_r.visible = false

func shock_vave_timer_timeout():
	shock_vave_impulse = false

func shock_wave_hit(node: Node) -> void:
	var distance: float = node.global_position.distance_to(global_position)
	
	# Too far from explosion blast wave....
	if distance > 2000:
		return
	
	print(name + ": explosion shock wave, hit by: " + node.name)
	print(name + ": explosion distance: " + str(int(distance)))

	# shockwave power based on distance:
	if distance >= 0 and distance <= 600:
		shock_vave_power = Vector2(-300, -4700)
		shock_vave_timer.start(0.3)
	if distance >= 600 and distance <= 1200:
		shock_vave_power = Vector2(-600, -3000)
		shock_vave_timer.start(0.2)
	if distance >= 1200 and distance <= 1900:
		shock_vave_power = Vector2(-1200, -2500)
		shock_vave_timer.start(0.15)

	# explosion is on right Player side:
	if global_position < node.global_position:
		shock_vave_direction = Vector2.LEFT
	
	# explosion is on left Player side:
	if global_position > node.global_position:
		shock_vave_direction = Vector2.RIGHT
		
	shock_vave_impulse = true

func get_state():
	return Player_state

func _process(_delta: float) -> void:
	pass


# func _physics_process(delta):
# 	if get_node("car/frontwheel").get_colliding_bodies().size() == 0 and get_node("car/backwheel").get_colliding_bodies().size() == 0:
# 		if Input.is_action_pressed("ui_up"):
# 			get_node("car").angular_velocity -= 0.3
# 		if Input.is_action_pressed("ui_down"):
# 			get_node("car").angular_velocity += 0.3
# 	else:
# 		if Input.is_action_pressed("ui_up"):
# 			get_node("car/frontwheel").angular_velocity = 30
# 			get_node("car/backwheel").angular_velocity = 30
# 		if Input.is_action_pressed("ui_down"):
# 			get_node("car/frontwheel").angular_velocity = 0
# 			get_node("car/backwheel").angular_velocity = 0

func _physics_process(_delta) -> void:
	
	if Input.is_action_pressed("ui_right"):
		for wheel in wheels:
			#wheel.angular_velocity = 30
			#if rpm_power <= 100:
				#rpm_power += 0.1
				#$Rpm_power.value = rpm_power
				#pass
			#wheel.apply_torque_impulse(torqe_impulse * delta * 60)
			if rpm_power > 500:
				wheel.angular_velocity = rpm_power * 0.01

		if rpm_power <= rpm_limit:
			rpm_power += 20
			#$Rpm_power.value = rpm_power
			#$Rpm_power/rpm.set_text("RPM: " + str(rpm_power))
			drive_loop.volume_db += 0.1

	if Input.is_action_just_released("ui_right"):
		rpm_reduction = true

	if Input.is_action_pressed("ui_left"):
		for wheel in wheels:
			wheel.angular_velocity = -30
			rpm_power = 0
			$Rpm_power.value = rpm_power
			#wheel.apply_torque_impulse(-torqe_impulse * delta * 60)	
			
	if Input.is_action_just_released("ui_left"):
		rpm_reduction = true		
		
	speed_kmh = abs(int(get_velocity().x * 0.04))

	if rpm_reduction == true:
		rpm_power -= speed_kmh
		if drive_loop.volume_db > 1.0:
			drive_loop.volume_db -= 0.5

		if rpm_power <= 0:
			drive_loop.volume_db = linear_to_db(1.0)
			rpm_reduction = false
			rpm_power = rpm_idle
		
	$Rpm_power.value = rpm_power
	$Rpm_power/rpm.set_text("RPM: " + str(rpm_power))
	
	
	$Speed.value = speed_kmh
	$Speed/kmh.set_text("km/h: " + str(speed_kmh))
	

	check_raycasts()

	if shock_vave_impulse == true:
		if shock_vave_direction == Vector2.LEFT:
			apply_impulse(shock_vave_power, Vector2(300, 0))
		elif shock_vave_direction == Vector2.LEFT:
			apply_impulse(shock_vave_power, Vector2(-300, 0))

	# print(name + ": velocity x: " + str(int(linear_velocity.x)) )

	
	# ARROW-> UP CAR JUMP:	
	if Input.is_action_pressed("ui_up"):
		apply_impulse(Vector2(200, -3210), Vector2(300, 0))
		

	# if gv.Player_current_weapon != 0:
	# GO --> Switch weapon	
	if Input.is_action_just_pressed("Weapon"):
			get_node("snd_switch_weapon").play()
			gv.load_next_weapon()
			print(name + ": switch weapon")

	# Show Help information	
	if Input.is_action_just_pressed("Help"):
			get_node("../HUD").show_help()
			print(name + ": press Help key")

	# Hide Help information	
	if Input.is_action_just_released("Help"):
			get_node("../HUD").hide_help()
			print(name + ": release Help key")

	# Gas pedal	
	if Input.is_action_just_released("Gas"):
			print(name + ": press gas")

	# if rpm_power < 10.0:
	# 	drive_loop.stream_paused = true
	# else:
	# 	drive_loop.pitch_scale = maxf(0.001, 1.0 + (rpm_power - baseline_rpm) / pitch_scale)
	# 	drive_loop.stream_paused = false		
	# rpm_idle
	drive_loop.pitch_scale = maxf(0.001, 1.0 + (rpm_power - baseline_rpm) / pitch_scale)				

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

func check_raycasts() -> void:
	# touch RIGHT wheel ground checking:
	if FloorRayCast_R.is_colliding():
		if on_floor_r == true:
			pass
		else:
			$snd_hit2.play()
			on_floor_r = true
			print(name + ": On floor R")
	else:
		if on_floor_r == false:
			pass
		else:
			on_floor_r = false
			print(name + ": Not on floor R")

	# touch LEFT wheel ground checking:
	if FloorRayCast_L.is_colliding():
		if on_floor_l == true:
			pass
		else:
			$snd_hit2.play()
			on_floor_l = true
			print(name + ": On floor L")
	else:
		if on_floor_l == false:
			pass
		else:
			on_floor_l = false
			print(name + ": Not on floor L")

func _integrate_forces(_state):
	pass
	
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

		_sign = randi_range(0, 1)

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

func rpg_hit() -> void:
	$CollisionPolygon2D.set_deferred("disabled", true)
	#$MaluchArea2D/CollisionPolygon2D.set_deferred("disabled", true)
	$BigExplosion.visible = true
	$BigExplosion.explode()
	$smoke_particles.emitting = false
	$smoke_particles.visible = false
	_tween()
	await get_tree().create_timer(0.3).timeout
	$Bullet_holes.vanish()
	get_node("snd_engine").stop()
	$snd_player.stop()
	
func bomb_explode() -> void:
	$CollisionPolygon2D.set_deferred("disabled", true)
	#$MaluchArea2D/CollisionPolygon2D.set_deferred("disabled", true)
	$BigExplosion.visible = true
	$BigExplosion.explode()
	$smoke_particles.emitting = false
	$smoke_particles.visible = false
	await get_tree().create_timer(0.3).timeout
	$Bullet_holes.vanish()
	get_node("snd_engine").stop()
	$snd_player.stop()
	_tween()

func hit() -> void:
	if hit_count > 0:
		print(name + ": got hit " + "hits: " + str(hit_count))
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
			get_node("snd_engine").stop()
			$snd_player.stop()
			_tween()
			gv.Cam1.ScreenShake(30, 0.5)
			#queue_free()	

func on_gun_fire() -> void:
	anim_player.play("shoot")
	$Driver/AnimationPlayer.play("shoot")
	apply_impulse(Vector2(-2120, 0), Vector2(0, 0))

func flip_h(flip: bool):
	var x_axis = global_transform.x
	global_transform.x.x = (-1 if flip else 1) * abs(x_axis.x)

func flip_v(flip: bool):
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

	
func _on_front_contact_area_entered(_area: Area2D) -> void:
	# print("Fiat125p, front contact area: " + area.name)
	# $snd_hit.play()
	pass
	
func _on_front_contact_body_entered(body: Node2D) -> void:
	if body.name != "Fiat125p_rigid" and body.name != "Wheel":
	# 	if body.get_parent().has_method("hit"):
	# 		body.get_parent().hit()

		# match str(body.name):
		# 	"BarellBodyCollision":
		# 		body.get_parent().hit()
			# "Barrel_2":
			# 	body.hit()
			
		# 		print("QQQQQQQQQQQQQQQQQQQQQQQQQQQQQ")

		# if body.name == "Barrel_2":Barell_2
		# 	body.hit()

		$snd_hit2.play()
		print(name + ": front contact Area2D hit body: " + body.name)


func _on_back_contact_area_entered(_area: Area2D) -> void:
	# print("Fiat125p, back contact area: " + area.name)
	# $snd_hit.play()
	pass

func _on_back_contact_body_entered(body: Node2D) -> void:
	if body.name != "Fiat125p_rigid":
		$snd_hit.play()
		print(name + ": back contact body: " + body.name)


func _on_floor_contact_area_entered(_area: Area2D) -> void:
	# print("Fiat125p, floor contact area: " + area.name)
	# $snd_touch_ground.play()
	pass

func _on_floor_contact_body_entered(body: Node2D) -> void:
	if body.name != "Fiat125p_rigid":
		$snd_touch_ground.play()
		print(name + ": floor contact body: " + body.name)


func _on_top_contact_body_entered(body: Node2D) -> void:
	if body.name != "Fiat125p_rigid":
		$snd_touch_ground.play()
		print(name + ": top contact body: " + body.name)


func _on_big_explosion_finished() -> void:
	for wheel in wheels:
			wheel.queue_free()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	Player_on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	Player_on_screen = false

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	$Driver/AnimationPlayer.play("head_rotate")