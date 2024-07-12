extends RysiekState

# #####################
# # WALK RIGHT.SCRIPT #
# #####################

@onready var ray_cast:RayCast2D = get_node("../../PlayerCast2D")
var player_distance:float
#var timer:Timer
var stop:bool = false

func enter(_msg := {}) -> void:
	rysiek.anim_player.stop()
	rysiek.turn_right()
	rysiek.anim_player.play("walk")
	#timer = Timer.new()
	#add_child(timer)
	#timer.set_one_shot(true)
	#timer.set_wait_time(1)
	#timer.connect("timeout",  _timer_timeout)
	print("Rysiek state: Walk_right")
	
# Exit state:	
func exit() -> void:
	gv.rysiek_fsm.previous_state = "Walk_right"
	print("Rysiek state: Exit Walk_right state")

func _timer_timeout():
	pass

@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:
	rysiek.velocity.x = rysiek.speed
	rysiek.velocity.y += rysiek.gravity * delta
	player_distance = rysiek.global_position.distance_to(gv.Player.global_position)

	# GAME PAUSE:
	""" if gv.Game_pause == true:
		rysiek.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """
	
	# print("player distance: " + str(int(player_distance)))
		
	if get_node("../../snd_walk").playing != true:
			get_node("../../snd_walk").play()
			
		
		
	#if gv.fsm.state.name == "Idle" or gv.fsm.state.name == "target_up" or gv.fsm.state.name == "target_down":
		#timer.start()
		#if gv.Enemy_direction == Vector2.RIGHT:
		#if is_equal_approx(player_distance, rysiek.contact_distance):
	if player_distance > rysiek.contact_distance * 5:
		# if gv.Hero_pos_x + rysiek.change_direction_distance < rysiek.position.x:
		# 	rysiek.scale.x = rysiek.scale.y * 1
		# 	rysiek.direction = "L"
		# if gv.Hero_pos_x - rysiek.change_direction_distance > rysiek.position.x:
		# 	rysiek.scale.x = rysiek.scale.y * -1
		# 	rysiek.direction = "R"

		rysiek.anim_player.stop()
		#rysiek.previous_state = gv.rysiek_fsm.estate.name
		rstate_machine.transition_to("idle")	
			
	rysiek.move_and_slide()		

	if rysiek.is_on_wall():
		rysiek.anim_player.stop()
		print("enemy2: stop on wall going right")
		rstate_machine.transition_to("Jump_right")

	if rysiek.is_on_floor() == false:
		rstate_machine.transition_to("Air")			

func _on_enemy_somebody_hitme() -> void:
	if gv.rysiek_fsm.rstate.name == "Walk_Right":
		rstate_machine.transition_to("Hit")
	
	
	
	
	
	
	
	
	
	
#	if stop == true:
#		if player_distance >= rysiek.contact_distance:
#			if gv.Hero_pos_x + rysiek.change_direction_distance < rysiek.position.x:
#				rysiek.scale.x = rysiek.scale.y * 1
#			if gv.Hero_pos_x - rysiek.change_direction_distance > rysiek.position.x:
#				rysiek.scale.x = rysiek.scale.y * -1
#
#			stop = false
#			get_node("../../AnimationPlayer").stop()
#			rysiek.previous_state = gv.enemy_fsm.estate.name
#			estate_machine.transition_to("idle")
		
	
	

# print(rysiek.global_position.distance_to(gv.Hero_global_position))
# print(rysiek.global_position.distance_to(rysiek.player_collision_point))
	

# print(randi_range(50,2800))

#if rysiek.global_position.distance_to(gv.Hero_global_position)	> rysiek.contact_distance:
		

#stop_delay += 1
		
#	if ray_cast.is_colliding():
#		if ray_cast.get_collider().name == "Player":
#			rysiek.player_collision_point = ray_cast.get_collision_point()
#
#			# print("rysiek: ray hit Player")
#			# print("rysiek: distance to player --> " + 
#			# str(int(rysiek.position.distance_to
#			# (rysiek.player_collision_point))))
#
#			if rysiek.position.distance_to(rysiek.player_collision_point) > rysiek.contact_distance + 100:
#				rysiek.previous_state = gv.enemy_fsm.estate.name
#				get_node("../../AnimationPlayer").stop()
#				estate_machine.transition_to("idle")
