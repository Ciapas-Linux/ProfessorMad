extends RigidBody2D

##############################################
# GDscript:									 #
# Fiat125p rigid body version				 #
# ENEMIES car converted into combat          #
#											 #	
##############################################



@export var hit_count:int = 12
@export var speed:float = 60000
#@export var spin_power = 10000

#var thrust = Vector2(0, -250)
#var torque = 20000

@onready var tween: Tween

var local_cursor_position:Vector2
var player_distance:float

const MOVE_RIGHT: int = 0
const MOVE_LEFT: int = 1
const STOP: int = 2

var mouse_enter:bool = false
var current_state : int = STOP
	
@onready var sounds:Array = [load("res://Assets/Sounds/Vehicles/pisk_opon1.wav"),
  	load("res://Assets/Sounds/Vehicles/pisk_opon2.wav"),
  	load("res://Assets/Sounds/Vehicles/pisk_opon3.wav")]
	

var wheels:Array[RigidBody2D] = []	
	
func _ready() -> void:
	self.input_pickable = true
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	$BigExplosion.visible = false
	print(name + ": start x: " + str(global_position.x))
	#apply_impulse(Vector2(12.0, 0).rotated(rotation))
	#apply_central_force(Vector2(10, 0) * 1)
	#apply_central_impulse(Vector2(0, -100))
	#apply_force(get_local_mouse_position().normalized() * 20)
	#apply_central_impulse(Vector2(0, -100))
	#add_constant_force( Vector2(1000, 0), Vector2(0, 0) )
	#wheels = get_tree().get_nodes_in_group(
	#wheels = $WheelHolder/Wheel.get_tree().get_nodes_in_group("wheel")
	#wheels[0] = $WheelHolder.get_node("Wheel")
	wheels.append($WheelHolder.get_node("Wheel"))
	wheels.append($WheelHolder2.get_node("Wheel")) 
	#start_drive(MOVE_RIGHT)
	$smoke_particles.emitting = true
	get_node("snd_engine").play()
	#$Driver.scale.x = $Driver.scale.y * -1
	$Driver/AnimationPlayer.play("head_rotate")
	#turn_right()
		

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
	if gv.Player.Player_current_weapon == 3:
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
	pass

func _process_on_state_move_right(_delta: float) -> void:
	#velocity.x = speed
	#velocity.y += gravity * delta
	#constant_force = Vector2.RIGHT
	#constant_torque = 12.0
	#apply_central_impulse(Vector2(0, -10))
	#apply_torque_impulse(-100)
	player_distance = global_position.distance_to(gv.Player.global_position)
	#move_and_slide()
	

func _process_on_state_move_left(_delta: float) -> void:
	#velocity.x = -speed
	#velocity.y += gravity * delta
	player_distance = global_position.distance_to(gv.Player.global_position)
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
		print(name + ": dostałem " + "hits: " + str(hit_count))
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
	

func _on_front_contact_area_entered(area:Area2D) -> void:
	print(name + ": hit area: " + area.name)
	$snd_hit.play()
	# match current_state:
	# 	STOP:
	# 		pass
	# 	MOVE_RIGHT:
	# 		turn_left()
	# 	MOVE_LEFT:
	# 		turn_right()

func _on_front_contact_body_entered(body:Node2D) -> void:
	print(name + ": hit body: " + body.name)
	$snd_hit.play()


func _on_big_explosion_finished() -> void:
	for wheel in wheels:
			wheel.queue_free()
	queue_free() 












