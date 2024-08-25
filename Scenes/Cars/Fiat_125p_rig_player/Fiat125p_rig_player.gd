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


var mouse_enter:bool = false

	
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
var Player_guns = {"no": 0, "ak_47": 1, "rpg_7": 2, "rocket_4": 3,"tt_gun": 4}
var Player_current_weapon:int = Player_guns["ak_47"]

var shock_vave_timer:Timer
var impulse:bool = false

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

	gv.load_inventory()

	shock_vave_timer = Timer.new()
	add_child(shock_vave_timer)
	shock_vave_timer.wait_time = 0.1
	shock_vave_timer.one_shot = true
	shock_vave_timer.connect("timeout", _shock_vave_timer_timeout)

	print("Node ready:" + self.name)
	print(self.name + " start x: " + str(global_position.x))

	# turn_right()
	# flip_v(true)

func _shock_vave_timer_timeout():
	impulse = false

func get_state():
	return Player_state		

func _process(_delta: float) -> void:
	pass	

func _physics_process(delta) -> void:
	if Input.is_action_pressed("ui_right"):
		for wheel in wheels:
			wheel.apply_torque_impulse(speed * delta * 60)
	if Input.is_action_pressed("ui_left"):
		for wheel in wheels:
			wheel.apply_torque_impulse(-speed * delta * 60)
		
	if impulse == true:
			apply_impulse(Vector2(0, -6210),Vector2(300,0))


	# ARROW-> DOWN:	
	if Input.is_action_pressed("ui_down"):
		apply_impulse(Vector2(0, -6210),Vector2(300,0))
		#apply_impulse(Vector2(120, 6210),Vector2(0,0))

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
			print("Player: release Help key")				
					

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

func shock_wave_hit(node:Node)-> void:
	print(name + ": explosion shock wave, hit by: " + node.name)
	var distance : float = node.global_position.distance_to(global_position)
	print(name + ": explosion distance: " + str(int(distance)))
	shock_vave_timer.start()
	impulse = true


func rpg_hit()-> void:
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
	
func bomb_explode()-> void:
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

func hit()-> void:
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
			gv.Cam1.ScreenShake(30,0.5)
			#queue_free()	

func on_gun_fire() -> void:
	anim_player.play("shoot")
	$Driver/AnimationPlayer.play("shoot")
	apply_impulse(Vector2(-2120, 0),Vector2(0,0))

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

	
func _on_front_contact_area_entered(_area:Area2D) -> void:
	# print("Fiat125p, front contact area: " + area.name)
	# $snd_hit.play()
	pass
	
func _on_front_contact_body_entered(body:Node2D) -> void:
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


func _on_back_contact_area_entered(_area:Area2D) -> void:
	# print("Fiat125p, back contact area: " + area.name)
	# $snd_hit.play()
	pass

func _on_back_contact_body_entered(body:Node2D) -> void:
	if body.name != "Fiat125p_rigid":	
		$snd_hit.play()
		print(name + ": back contact body: " + body.name)


func _on_floor_contact_area_entered(_area:Area2D) -> void:
	# print("Fiat125p, floor contact area: " + area.name)
	# $snd_touch_ground.play()
	pass

func _on_floor_contact_body_entered(body:Node2D) -> void:
	if body.name != "Fiat125p_rigid":
		$snd_touch_ground.play()
		print(name + ": floor contact body: " + body.name)


func _on_top_contact_body_entered(body:Node2D) -> void:
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

func _on_animation_player_animation_finished(_anim_name:StringName) -> void:
	$Driver/AnimationPlayer.play("head_rotate")