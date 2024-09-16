extends PlayerState


#.######################>
#. PROFESOR IDLE 🌟🌟🌟#>
#.######################>


@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer")

var ray_normal:Vector2
var offset: float
var floor_normal:Vector2
#var node_enter:int = 0

# Enter state:
func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	get_node("../../snd_walk").stop()
		
	if anim_player.current_animation != "touch_down":
		select_animation()

	# if player.Player_weapon.is_connected("fire", _on_gun_2_fire) == false:
	# 	print("Player: XXXXXXXXXXXXXXXXXXXXXX")
	# 	player.Player_weapon.connect("fire", _on_gun_2_fire)
	# 	if player.Player_weapon.is_connected("fire", _on_gun_2_fire) == false:
	# 		print("Player: XXXXXXXXXXXXXXXXXXXXXX")

	print("Player: previous state " + player.Player_fsm.previous_state)
	print("Player state: " + self.name)
	#node_enter+=1
	#print("Player: Idle enter nr: " + str(node_enter))

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if player.Player_fsm.state.name == "Idle":
		if anim_name == "touch_down":
			select_animation()

# Exit state:	
func exit() -> void:
	print("Player exit state: " + self.name)
	

func physics_update(delta: float) -> void:

	if not player.is_on_floor():
		print("Player: Idle to air")
		state_machine.transition_to("Air")
		return
		
	if player.Player_is_paused == true:	
		return

	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	# if player.SlopeRayCast.is_colliding():

	# Rotate foot to match slope angle:
	if player.is_on_floor() and player.SlopeRayCast.is_colliding():
		offset = deg_to_rad(90)
		ray_normal =  player.SlopeRayCast.get_collision_normal()
		player.Player_tilt = (int)(rad_to_deg(ray_normal.angle() + offset ) * -1)
		
		# No slope:
		if player.Player_tilt < 10 and player.Player_tilt > -10:
			if anim_player.get_current_animation() != "idle":
				select_animation()
			player.Foot_R.rotation = ray_normal.angle() + deg_to_rad(90)
			player.Foot_L.rotation = ray_normal.angle() + deg_to_rad(90)
			player.Player_up_down = 0	# flat = 0
			get_node("../../CollisionShape2D").shape.height = 700	
		
		# Slope:
		elif player.Player_tilt > 10 or player.Player_tilt < -10:
			if anim_player.get_current_animation() != "idle_tilt":
				anim_player.play("idle_tilt")

			if player.Player_tilt < 0:
				if player.Player_direction == Vector2.RIGHT: # going DOWN: 2
					player.Foot_R.rotation = ray_normal.angle() + deg_to_rad(90)
					player.Foot_L.rotation = ray_normal.angle() + deg_to_rad(90)
					get_node("../../CollisionShape2D").shape.height = 730
					player.Player_up_down = 2
				if player.Player_direction == Vector2.LEFT: # going UP: 1
					player.Foot_R.rotation = -(ray_normal.angle() + deg_to_rad(90))
					player.Foot_L.rotation = -(ray_normal.angle() + deg_to_rad(90))
					get_node("../../CollisionShape2D").shape.height = 600	
					player.Player_up_down = 1

			if player.Player_tilt > 0:
				if player.Player_direction == Vector2.RIGHT: # going UP:
					player.Foot_R.rotation = ray_normal.angle() + deg_to_rad(90)
					player.Foot_L.rotation = ray_normal.angle() + deg_to_rad(90)
					get_node("../../CollisionShape2D").shape.height = 600	
					player.Player_up_down = 1
				if player.Player_direction == Vector2.LEFT: # going DOWN:
					player.Foot_R.rotation = -(ray_normal.angle() + deg_to_rad(90))
					player.Foot_L.rotation = -(ray_normal.angle() + deg_to_rad(90))
					get_node("../../CollisionShape2D").shape.height = 730	
					player.Player_up_down = 2


			#print( "Slope angle: " + str(slope_angle))
			#get_node("../../Skeleton2D/Base/Leg_L").position.y += 60
			#get_node("../../CollisionShape2D").shape.height = 600


	# Switch weapon	
	if Input.is_action_just_pressed("Weapon"):
			get_node("../../snd_switch_weapon").play()
			gv.load_next_weapon()
			select_animation()
			print("Player: switch weapon")

	# Show Help information	
	if Input.is_action_just_pressed("Help"):
			get_node("../../../HUD").show_help()
			print("Player: press Help key")

	# Hide Help information	
	if Input.is_action_just_released("Help"):
			get_node("../../../HUD").hide_help()
			print("Player: release Help key")				

	# GO --> Reload weapon
	if Input.is_action_just_pressed("Reload"):
		player.Player_weapon.reload()
		print("Player: reload weapon")

	# GO --> AIR
	if Input.is_action_just_pressed("ui_up"):
		state_machine.transition_to("Air", {do_jump = true})
			
	# GO --> Walk left
	if Input.is_action_pressed("ui_left"):
		if player.Player_is_paused == false:
			player.scale.x = player.scale.y * -1
			player.Player_direction = Vector2.LEFT
			state_machine.transition_to("Walk")
	
	# GO --> Walk right
	if Input.is_action_pressed("ui_right"):
		if player.Player_is_paused == false:
			player.Player_direction = Vector2.RIGHT
			player.scale.x = player.scale.y * 1
			state_machine.transition_to("Walk")
				
	# GO --> RUN:	
	if Input.is_action_pressed("run"):
		if player.Player_direction == Vector2.RIGHT: 
			state_machine.transition_to("run_right")
			player.scale.x = player.scale.y * 1
			
		if player.Player_direction == Vector2.LEFT: 
			state_machine.transition_to("run_left")
			player.scale.x = player.scale.y * -1	
					
	# TARGET UP:	
	if Input.is_action_just_pressed("Target"):
		state_machine.transition_to("target_up")
					

	# TARGET DOWN:	
	if Input.is_action_just_pressed("ui_down"):
		state_machine.transition_to("target_down")
		
	
func select_animation() -> void:
	if player.Player_current_weapon == 4:
		anim_player.play("idle_tt_gun")
		anim_player.seek(0.1)
	else:
		anim_player.play("idle")	
		anim_player.seek(0.1)














# player.Foot_R.rotation = -(norm.angle() + offset)


		# player.Foot_LL.rotation = norm.angle()  + offset
		
		# player.Foot_L.rotation = randf_range(-1,1)
		# player.Foot_R.rotation = norm.angle() + offset
		
		#print("#############: " + str(player.get_floor_angle()))
		#print("#############: " + str(norm.angle())) 

		# slope_angle = ray_normal.angle() + offset
		# print("#############: " + str(slope_angle)) 

		# if player.get_slide_collision_count() > 0:
		# 	collision = player.get_slide_collision(0)
		# 	normal = collision.get_normal()
		# 	#var normal2: Vector2 = player.get_floor_normal()
			
		# 	# math.acos(normal.dot(b))

		# 	#print("#############: " + str( collision.get_angle(Vector2(-1, 0)) ))
		# 	#print("#############: " + str(player.get_floor_angle()))
		# 	#print("#############: " + str(normal2.x))
		# 	#print("#############: " + str(normal2.aspect())) 

		# 	slope_angle = rad_to_deg(acos(normal.dot(Vector2(0, -1))))
			
		# 	player.Foot_R.rotation = slope_angle
		# 	player.Foot_L.rotation = slope_angle




		# var normal = side.get_collision_normal() 
		# rotation = normal.angle() + deg2rad(90)



#player.Foot_R.rotation = floor_normal.angle() + offset
		#player.Foot_L.rotation = floor_normal.angle() + offset


# # This function assumes that you are already using move_and_slide, and that a "slope" is a subtype of a "floor", so if is_on_slope() is true, then is_on_floor() must also be true.
# # If there are simultaneous collisions with both a "floor" and a "slope", then this returns false.
# func is_on_slope(max_floor_angle = DEFAULT_MAX_FLOOR_ANGLE):
# 	if player.is_on_floor():
# 		for i in range(player.get_slide_collision_count()):
# 			collision = player.get_slide_collision(i)
# 			# Is this a "floor" collision?
# 			if collision.normal.angle_to(UP) <= max_floor_angle:
# 				return false
# 		# We didn't find a "floor" collision, but is_on_floor() is true, so there must be a "slope" collision.
# 		return true
# 	# is_on_floor is false, so there cannot be a "slope" collision.
# 	return false


		
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
		
