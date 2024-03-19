
#.#############>
#. WALK       #>
#.#############>

extends PlayerState


var collision:KinematicCollision2D
var normal:Vector2
var slope_angle_deg:float = 0
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const DEFAULT_MAX_FLOOR_ANGLE = deg_to_rad(5)


@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer")

func enter(_msg := {}) -> void:
	anim_player.stop()
	


func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	if gv.Hero_is_paused == true:
		state_machine.transition_to("Idle")
		return	

	var input_direction_x: float = (
		Input.get_action_strength("ui_right")
		- Input.get_action_strength("ui_left"))
		
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	
		
	player.move_and_slide()

			
	if is_on_slope() == true:
		#print("$$$$$$$$$$$$$$$: " + str(slope_angle_deg))
		anim_player.play("walk_up")
	else:
		anim_player.play("walk")	
			

	if get_node("../../snd_walk").playing != true:
			get_node("../../snd_walk").play()	


	if Input.is_action_just_pressed("ui_up"):
		state_machine.transition_to("Air", {do_jump = true})
	elif is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")



# This function assumes that you are already using move_and_slide, and that a "slope" is a subtype of a "floor", so if is_on_slope() is true, then is_on_floor() must also be true.
# If there are simultaneous collisions with both a "floor" and a "slope", then this returns false.
func is_on_slope(max_floor_angle = DEFAULT_MAX_FLOOR_ANGLE):
	if player.is_on_floor():
		for i in range(player.get_slide_collision_count()):
			collision = player.get_slide_collision(i)
			# Is this a "floor" collision?
			if collision.get_normal().angle_to(UP) <= max_floor_angle:
				return false
		# We didn't find a "floor" collision, but is_on_floor() is true, so there must be a "slope" collision.
		return true
	# is_on_floor is false, so there cannot be a "slope" collision.
	return false

















# if player.is_on_floor():
	# 	if player.get_slide_collision_count() > 0:
	# 		collision = player.get_slide_collision(0)
	# 		normal = collision.get_normal()
	# 		slope_angle_deg = rad_to_deg(acos(normal.dot(Vector2(0, -1))))
	# 		if slope_angle_deg > 15:
	# 			get_node("../../AnimationPlayer").play("walk_up")
	# 		else:
	# 			get_node("../../AnimationPlayer").play("walk_2")	
	# 		#print("$$$$$$$$$$$$$$$: " + str(slope_angle_deg))
		


#if player.is_on_wall():
		#print("Hero: stop on wall going: " + str(input_direction_x))

	# print("$$$$$$$$$$$$$$$: " + str(input_direction_x))	
	# 1 Right <>  -1 left



# # Rotate shoes to slope angle:
# 	if player.is_on_floor():
# 		if player.get_slide_collision_count() > 0:
# 			collision = player.get_slide_collision(0)
# 			normal = collision.get_normal()
# 			#var normal2: Vector2 = player.get_floor_normal()
		
# 			slope_angle = rad_to_deg(acos(normal.dot(Vector2(0, -1))))
		
# 			#player.But_L_spr.rotation = player.get_floor_angle() 
# 			#player.But_P_spr.rotation = player.get_floor_angle()
# 			#player.rotation = -player.get_floor_angle() 





#var But_anim : Animation = get_node("../../AnimationPlayer").get_animation("walk_2")
	
	# var track_idx = animation.find_track( "../../leg_l/Lydka_l/But_l")
	# print("$$$$$$$$$$$$$$$: " + str(track_idx))
	# for track_indx in animation.get_track_count():
	# 	animation.track_get_path(track_indx)
	# 	print("********: " + str(animation.track_get_path(track_indx)) + "  :" +  str(track_indx))	

	

	# print("******** Player enter walk fsm ")


# leg_p/Lydka_p/But_p:position
# leg_p/Lydka_p/But_p:rotation





# var timer:Timer

# timer = Timer.new()
# 	add_child(timer)
# 	timer.set_one_shot(true)
# 	timer.set_wait_time(5)
# 	timer.connect("timeout",  _timer_timeout)
# 	timer.start()


#func _timer_timeout():
	#print("Hero Walk fsm: Timeout test pass ")
	#pass

# print("#############: " + str(player.get_floor_angle()))
		# print("#############: " + str(normal2.x))
		# print("#############: " + str(normal2.aspect())) 

		#But_L_spr.rotation = -player.get_floor_angle()
		#But_P_spr.rotation = -player.get_floor_angle()		

		#if input_direction_x == 1:
		#But_L_spr.rotation = normal.angle() + deg_to_rad(90)
		#elif input_direction_x == -1:
		#But_P_spr.rotation = normal.angle() + deg_to_rad(90)

		# var angleDelta = normal.angle() - (But_L_spr.rotation - PI)
		# But_L_spr.rotation = angleDelta + But_L_spr.rotation

	
	#But_L_spr.rotation =  player.get_floor_normal().angle() + PI/2
	#But_P_spr.rotation =  player.get_floor_normal().angle() + PI/2
	#But_L_spr.rotation = player.get_floor_angle() * input_direction_x
	#But_P_spr.rotation = player.get_floor_angle() * input_direction_x
	#But_L_spr.rotation = player.get_floor_angle()
	#But_P_spr.rotation = player.get_floor_angle()		
	#print("#############: " + str(player.get_floor_angle()))
	
			
	# var slope_angle = rad2deg(acos(get_collision_normal().dot(Vector2(0, -1))))



	# To make a kinematic body rotate on a slope
	# first you'll need to get the floor normal
	# either using a raycast2d, or by using the kinematic body's get_slide_collision()
	# Then you use atan2(normal.x, -normal.y) to get the rotation.

	# Use this whenever you want the alignment to happen:

	# var temp_scale = scale 
	# transform = align_with_y(transform, get_collision_normal()) 
	# scale = temp_scale

	# Here's the function that handles the math:

	# func align_with_y(xform, new_y): 
	# 	xform.basis.y = new_y 
	# 	xform.basis.x = -xform.basis.z.cross(new_y) 
	# 	xform.basis = xform.basis.orthonormalized() 
	# 	return xform





# await get_tree().create_timer(1000).timeout







