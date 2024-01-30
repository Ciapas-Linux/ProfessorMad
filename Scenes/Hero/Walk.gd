
#.#############>
#. WALK       #>
#.#############>

extends PlayerState

@onready var But_L_spr:Sprite2D = get_node("../../leg_l/But_L")
@onready var But_P_spr:Sprite2D = get_node("../../leg_p/But_P")

var timer:Timer

var collision:KinematicCollision2D
var normal:Vector2


func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	timer = Timer.new()
	add_child(timer)
	timer.set_one_shot(true)
	timer.set_wait_time(5)
	timer.connect("timeout",  _timer_timeout)
	timer.start()
	

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
	
	#if player.is_on_wall():
		#print("Hero: stop on wall going: " + str(input_direction_x))

	# print("$$$$$$$$$$$$$$$: " + str(input_direction_x))	
	# 1 Right <>  -1 left
	
	player.move_and_slide()

	if player.get_slide_collision_count() > 0:
		collision = player.get_slide_collision(0)
		normal = collision.get_normal()
		var normal2: Vector2 = player.get_floor_normal()
		
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


	get_node("../../AnimationPlayer").play("walk_2")
			
	if get_node("../../snd_walk").playing != true:
			get_node("../../snd_walk").play()	

	if Input.is_action_just_pressed("ui_up"):
		state_machine.transition_to("Air", {do_jump = true})
	elif is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")

func _timer_timeout():
	#print("Hero Walk fsm: Timeout test pass ")
	pass


# await get_tree().create_timer(1000).timeout
