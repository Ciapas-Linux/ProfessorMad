extends EnemyState

# #####################
# # WALK LEFT.SCRIPT  #
# #####################

var player_distance:float

func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	enemy.scale.x = enemy.scale.y * 1
	enemy.direction = "L"
	get_node("../../AnimationPlayer").play("walk")
	print("enemy fsm: WALK LEFT")
	

#@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:
	enemy.velocity.x = -enemy.speed
	enemy.velocity.y += enemy.gravity * delta
	player_distance = enemy.global_position.distance_to(gv.Hero_global_position)

	# GAME PAUSE:
	""" if gv.Game_pause == true:
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """
	
	if get_node("../../snd_walk").playing != true:
			get_node("../../snd_walk").play()
			
	if player_distance < enemy.contact_distance + 500:
		# if gv.Hero_pos_x + enemy.change_direction_distance < enemy.position.x:
		# 	enemy.scale.x = enemy.scale.y * 1
		# 	enemy.direction = "L"
		# if gv.Hero_pos_x - enemy.change_direction_distance > enemy.position.x:
		# 	enemy.scale.x = enemy.scale.y * -1
		# 	enemy.direction = "R"

		get_node("../../AnimationPlayer").stop()
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("idle")		

#	if enemy.see_Player == true:
#		get_node("../../AnimationPlayer").stop()
#		enemy.previous_state = gv.enemy_fsm.estate.name
#		estate_machine.transition_to("idle")
		
#	if enemy.position.distance_to(gv.Hero_global_position) > 500:
#		enemy.previous_state = gv.enemy_fsm.estate.name
#		get_node("../../AnimationPlayer").stop()
#		estate_machine.transition_to("idle")
	
			
	enemy.move_and_slide()

	if enemy.is_on_wall():	
		enemy.previous_state = gv.enemy_fsm.estate.name
		get_node("../../AnimationPlayer").stop()
		print("enemy2: stop on wall going left")
		estate_machine.transition_to("Jump_left")

	if enemy.is_on_floor() == false:
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Air")		