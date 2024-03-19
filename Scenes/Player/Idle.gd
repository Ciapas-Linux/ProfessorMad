#@uid("uid://cx8xk4374qt8n") # Generated automatically, do not modify.
extends PlayerState

signal turn(value)

@onready var Ray:RayCast2D = get_node("../../RayCast2D")
@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer")

var collision:KinematicCollision2D
var normal:Vector2

var slope_angle:float = 0

const UP = Vector2(0, -1)
const DEFAULT_MAX_FLOOR_ANGLE = deg_to_rad(5)

# Enter state:
func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	get_node("../../snd_walk").stop()
	get_node("../../snd_fall").stop()
	if anim_player.current_animation != "touch_down":
		#anim_player.stop()
		anim_player.play("idle")

	gv.Hero_is_on_floor = true
	if gv.Hero_weapon.is_connected("fire", _on_gun_2_fire) == false:
		gv.Hero_weapon.connect("fire", _on_gun_2_fire)

	# print("******** Player enter idle fsm ")

func _on_animation_player_2_animation_finished(anim_name:StringName):
	if anim_name == "touch_down":
		#anim_player.stop()
		anim_player.play("idle")
	

# Exit state:	
func exit(_msg := {}) -> void:
	pass

func physics_update(delta: float) -> void:

	player.velocity.y += player.gravity * delta

	if not player.is_on_floor():
		state_machine.transition_to("Air")
		gv.Hero_is_on_floor = false
		return
		
	if gv.Hero_is_paused == true:	
		return

	# if gv.Hero_current_weapon != 0:
	if Input.is_action_just_pressed("Weapon"):
			get_node("../../snd_switch_weapon").play()
			player.load_next_weapon()
			print("Player: switch weapon")

	if Input.is_action_just_pressed("Reload"):
		gv.Hero_weapon.reload()
		print("Player: reload weapon")

	if Input.is_action_just_pressed("ui_up"):
		state_machine.transition_to("Air", {do_jump = true})
	
	# input left
	if Input.is_action_pressed("ui_left"):
		if gv.Hero_is_paused == false:
			player.scale.x = player.scale.y * -1
			gv.Hero_direction = Vector2.LEFT
			state_machine.transition_to("Walk")
			turn.emit(false)  
	
	# input right
	if Input.is_action_pressed("ui_right"):
		if gv.Hero_is_paused == false:
			gv.Hero_direction = Vector2.RIGHT
			player.scale.x = player.scale.y * 1
			state_machine.transition_to("Walk")
			turn.emit(true)
		
		
	# RUN RIGHT:	
	if Input.is_action_pressed("run") and Input.is_action_pressed("ui_right"):
		state_machine.transition_to("run_right")
		player.scale.x = player.scale.y * 1
		gv.Hero_direction = Vector2.RIGHT
		
		
	# RUN LEFT:	
	if Input.is_action_pressed("run") and Input.is_action_pressed("ui_left"): 
		state_machine.transition_to("run_left")
		player.scale.x = player.scale.y * -1
		gv.Hero_direction = Vector2.LEFT
				
		
	# TO AIM:	
	if Input.is_action_just_pressed("Target"):
		state_machine.transition_to("target_up")
		#player.scale.x = player.scale.y * 1
		#gv.hero_sprite.set_flip_h(false) 
		
	# SIT DOWN:	
	if Input.is_action_just_pressed("ui_down"):
		state_machine.transition_to("target_down")
		#player.scale.x = player.scale.y * 1
		#gv.hero_sprite.set_flip_h(false)

	
	player.move_and_slide()

	
			 		

# This function assumes that you are already using move_and_slide, and that a "slope" is a subtype of a "floor", so if is_on_slope() is true, then is_on_floor() must also be true.
# If there are simultaneous collisions with both a "floor" and a "slope", then this returns false.
func is_on_slope(max_floor_angle = DEFAULT_MAX_FLOOR_ANGLE):
	if player.is_on_floor():
		for i in range(player.get_slide_collision_count()):
			collision = player.get_slide_collision(i)
			# Is this a "floor" collision?
			if collision.normal.angle_to(UP) <= max_floor_angle:
				return false
		# We didn't find a "floor" collision, but is_on_floor() is true, so there must be a "slope" collision.
		return true
	# is_on_floor is false, so there cannot be a "slope" collision.
	return false

func _on_gun_2_fire() -> void:
	if gv.fsm.state.name == "Idle":
		#get_node("../../AnimationPlayer").stop()
		#get_node("../../AnimationPlayer").play("RESET")
		if player.turn == true:
			player.position.x -= 3
		else:	
			player.position.x += 3




















		
# func _on_gun_2_fire_stop() -> void:
# 	if gv.fsm.state.name == "Idle":
# 		#get_node("../../AnimationPlayer").stop()
# 		#get_node("../../AnimationPlayer").play("idle")	
# 	pass	

#if player.is_on_floor():
# 		if player.get_slide_collision_count() > 0:
# 			collision = player.get_slide_collision(0)
# 			normal = collision.get_normal()
# 			#var normal2: Vector2 = player.get_floor_normal()
			
# 			# math.acos(normal.dot(b))

# 			#print("#############: " + str( collision.get_angle(Vector2(-1, 0)) ))
# 			#print("#############: " + str(player.get_floor_angle()))
# 			#print("#############: " + str(normal2.x))
# 			#print("#############: " + str(normal2.aspect())) 

# 			slope_angle = rad_to_deg(acos(normal.dot(Vector2(0, -1))))




#print("#############: " + str(slope_angle))

			#var angleDelta = normal.angle() - (But_L_spr.rotation - PI)
			#But_L_spr.rotation = angleDelta + But_L_spr.rotation	

		# normal.angle_to(Vector3(0, 1, 0))	

		# Vector2 slide ( Vector2 n ) const

		# Result angle: 0.78 going Up
		# 0.78 standing down
			#player.But_L_spr.global_rotation = player.get_floor_angle() 
			#player.But_P_spr.rotation = player.get_floor_angle()

			#player.rotation = -player.get_floor_angle() 
			#player.rotation =- player.get_floor_angle()

			# But_L_spr.rotation = atan2(normal.x, -normal.y)
			# But_P_spr.rotation = atan2(normal.x, -normal.y)  		



		
		#get_node("../../AnimationPlayer").stop()
		#get_node("../../AnimationPlayer").play("idle")	
		
	# print("ASSSSSSSSSS ---->" + name)	
		
		
		
# if Ray.is_colliding():
	# 	player.draw_line(Ray.position, player.to_local(Ray.get_collision_point()), Color(1, 0, 0), 2,true)
	# 	var collider = Ray.get_collider()
	# 	if collider.has_method("do_thing"):
	# 		collider.do_thing()

	#player.But_P_spr.rotation = randf_range(100,100) #player.get_floor_angle()

	#var laserOrigin = to_local(Ray.global_position)		
		








