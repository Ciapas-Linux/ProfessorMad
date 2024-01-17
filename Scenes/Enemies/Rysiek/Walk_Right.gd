extends EnemyState

# #####################
# # WALK RIGHT.SCRIPT #
# #####################

@onready var ray_cast:RayCast2D = get_node("../../PlayerCast2D")
var player_distance:float
#var timer:Timer
var stop:bool = false

func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	enemy.scale.x = enemy.scale.y * -1
	enemy.direction = "R"
	get_node("../../AnimationPlayer").play("walk")
	#timer = Timer.new()
	#add_child(timer)
	#timer.set_one_shot(true)
	#timer.set_wait_time(1)
	#timer.connect("timeout",  _timer_timeout)
	print("enemy fsm: WALK RIGHT")
	
func _timer_timeout():
	pass

@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:
	enemy.velocity.x = enemy.speed
	enemy.velocity.y += enemy.gravity * delta
	player_distance = enemy.global_position.distance_to(gv.Hero_global_position)

	# GAME PAUSE:
	""" if gv.Game_pause == true:
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """
	
	# print("player distance: " + str(int(player_distance)))
		
	if get_node("../../snd_walk").playing != true:
			get_node("../../snd_walk").play()
			
		
		
	#if gv.fsm.state.name == "Idle" or gv.fsm.state.name == "target_up" or gv.fsm.state.name == "target_down":
		#timer.start()
		#if gv.Enemy_direction == Vector2.RIGHT:
		#if is_equal_approx(player_distance, enemy.contact_distance):
	if player_distance > enemy.contact_distance + 500:
		# if gv.Hero_pos_x + enemy.change_direction_distance < enemy.position.x:
		# 	enemy.scale.x = enemy.scale.y * 1
		# 	enemy.direction = "L"
		# if gv.Hero_pos_x - enemy.change_direction_distance > enemy.position.x:
		# 	enemy.scale.x = enemy.scale.y * -1
		# 	enemy.direction = "R"

		get_node("../../AnimationPlayer").stop()
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("idle")	


			
	enemy.move_and_slide()		

	if enemy.is_on_wall():
		enemy.previous_state = gv.enemy_fsm.estate.name
		get_node("../../AnimationPlayer").stop()
		print("enemy2: stop on wall going right")
		estate_machine.transition_to("Jump_right")

	if enemy.is_on_floor() == false:
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Air")			

func _on_enemy_somebody_hitme() -> void:
	if gv.enemy_fsm.estate.name != "Hit":
		enemy.previous_state = gv.enemy_fsm.estate.name
	estate_machine.transition_to("Hit")
	
	
	
	
	
	
	
	
	
	
#	if stop == true:
#		if player_distance >= enemy.contact_distance:
#			if gv.Hero_pos_x + enemy.change_direction_distance < enemy.position.x:
#				enemy.scale.x = enemy.scale.y * 1
#			if gv.Hero_pos_x - enemy.change_direction_distance > enemy.position.x:
#				enemy.scale.x = enemy.scale.y * -1
#
#			stop = false
#			get_node("../../AnimationPlayer").stop()
#			enemy.previous_state = gv.enemy_fsm.estate.name
#			estate_machine.transition_to("idle")
		
	
	

# print(enemy.global_position.distance_to(gv.Hero_global_position))
# print(enemy.global_position.distance_to(enemy.player_collision_point))
	

# print(randi_range(50,2800))

#if enemy.global_position.distance_to(gv.Hero_global_position)	> enemy.contact_distance:
		

#stop_delay += 1
		
#	if ray_cast.is_colliding():
#		if ray_cast.get_collider().name == "Player":
#			enemy.player_collision_point = ray_cast.get_collision_point()
#
#			# print("enemy: ray hit Player")
#			# print("enemy: distance to player --> " + 
#			# str(int(enemy.position.distance_to
#			# (enemy.player_collision_point))))
#
#			if enemy.position.distance_to(enemy.player_collision_point) > enemy.contact_distance + 100:
#				enemy.previous_state = gv.enemy_fsm.estate.name
#				get_node("../../AnimationPlayer").stop()
#				estate_machine.transition_to("idle")
