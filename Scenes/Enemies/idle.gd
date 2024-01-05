extends EnemyState

# #################
# # IDLE  .SCRIPT #
# #################

@onready var ray_cast:RayCast2D = get_node("../../PlayerCast2D")

signal first_hero_catch

func enter(_msg := {}) -> void:
	enemy.velocity = Vector2.ZERO
	get_node("../../snd_walk").stop()
	#get_node("../../snd_fall").stop()
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("idle")
	print("enemy fsm: IDLE")
		
 
@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:
	if not enemy.is_on_floor():
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Air")
		return
		
	# GAME PAUSE:
	""" if gv.Game_pause == true:
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """


	# print("XXXXXXXXX: " + str(int(enemy.global_position.distance_to(gv.Hero_global_position))))
		

	# TURN LEFT: player is on left side
	# if gv.Hero_global_position.x + enemy.change_direction_distance < enemy.global_position.x:
	if gv.Hero_global_position.x < enemy.global_position.x:
		if enemy.direction == "R":	
			enemy.scale.x = enemy.scale.y * 1
			enemy.direction = "L"
	
	# TURN RIGHT: player is on right side
	if gv.Hero_global_position.x > enemy.global_position.x:
		if enemy.direction == "L":
			enemy.scale.x = enemy.scale.y * -1
			enemy.direction = "R"
	
	# SEE PLAYER:					
	if 	enemy.see_Player == true:		
		if enemy.first_hero_catch == false:
			#emit_signal("first_hero_catch")
			enemy.first_hero_catch = true

			# This enemy cloud say information:
			enemy.chat_instance = enemy.Chat.instantiate()
			enemy.chat_instance.Say("Eeeee ty \ncwaniaczku !!!",6,0,220)
			enemy.get_tree().root.add_child(enemy.chat_instance)
			#enemy.chat_instance.connect('early_hit', _on_bomb_early_hit)
			print("enemy: First time see profesor")

			# PAUSE:
			# get_tree().paused = true

			#get_node("../../snd_first_see").play()
			
	# ESCAPE:		
	""" if enemy.global_position.distance_to(gv.Hero_global_position) <= enemy.contact_distance:
		#if get_node("../../Say").visible == false:
		if enemy.direction == "R":
			enemy.previous_state = gv.enemy_fsm.estate.name
			estate_machine.transition_to("Walk_Left")
		if enemy.direction == "L":
			enemy.previous_state = gv.enemy_fsm.estate.name
			estate_machine.transition_to("Walk_Right")	 """

	# Atack1:		
	""" if enemy.global_position.distance_to(gv.Hero_global_position) <= enemy.Atack1_distance and enemy.global_position.distance_to(gv.Hero_global_position) > enemy.Atack1_distance/2: 
		#if get_node("../../Say").visible == false:
		if enemy.direction == "R":
			enemy.previous_state = gv.enemy_fsm.estate.name
			print("enemy2: Atack jump right")
			estate_machine.transition_to("Jump_right")
		if enemy.direction == "L":
			enemy.previous_state = gv.enemy_fsm.estate.name
			print("enemy2: Atack jump left")
			estate_machine.transition_to("Jump_left")	 """		
					
	# WALK LEFT				
	if enemy.global_position.distance_to(gv.Hero_global_position) >= enemy.follow_distance:
		#if get_node("../../Say").visible == false:
		if enemy.direction == "R":
			enemy.previous_state = gv.enemy_fsm.estate.name
			estate_machine.transition_to("Walk_Right")
		if enemy.direction == "L":
			enemy.previous_state = gv.enemy_fsm.estate.name
			estate_machine.transition_to("Walk_Left")
		
	
	
func _on_enemy_somebody_hitme() -> void:
	if gv.enemy_fsm.estate.name != "Hit":
		enemy.previous_state = gv.enemy_fsm.estate.name
	estate_machine.transition_to("Hit")
		

#	print("XXXXXXXXX: " + str(int(enemy.global_position.distance_to(gv.Hero_global_position))))
			# (enemy.player_collision_point))))
						
	#else:
		#pass
		#print("enemy: ray hit --> " + ray_cast.get_collider().name)	
	





#if ray_cast.is_colliding():
#		if ray_cast.get_collider().name == "Player":
#			enemy.player_collision_point = ray_cast.get_collision_point()
#
#			if enemy.first_hero_catch == false:
#				emit_signal("first_hero_catch")
#				enemy.first_hero_catch = true
#				print("enemy: First time see profesor")
#				get_node("../../snd_first_see").play()
#
#			if enemy.global_position.distance_to(enemy.player_collision_point) < enemy.contact_distance:
#				if get_node("../../Say").visible == false:
#					enemy.previous_state = gv.enemy_fsm.estate.name
#					estate_machine.transition_to("Walk_Right")
#
#			# print(str(int(enemy.global_position.distance_to
#			# (enemy.player_collision_point))))
#
#		else:
#			pass
#			#print("enemy: ray hit --> " + ray_cast.get_collider().name)	
#
#
#
		
		
		
# func _on_say_it_was_shown() -> void:
# 	print("_on_say_it_was_shown()")
	
	
	
	
	
	
	
	
	
	
#	if gv.Enemy_position.distance_to(gv.Hero_local_position) < enemy.contact_distance:
#		enemy.previous_state = gv.enemy_fsm.estate.name
#		estate_machine.transition_to("Walk_Right")
		
#	if enemy.position.distance_to(gv.Hero_position) > 1300:
#		enemy.previous_state = gv.enemy_fsm.estate.name
#		estate_machine.transition_to("Follow_left")
			
#if get_node("../../snd_first_see").playing != true:
					
	
# print("enemy: ray hit Player")
			# print("enemy: distance to player --> " + 
			# str(int(enemy.position.distance_to
			# (enemy.player_collision_point))))	
	
#get_node("../../AnimationPlayer").stop()	

# enemy.look_at(gv.Hero_position)
	# var EnemyToPlayer = Player.translation - translation		
	# gv.Hero_position.


#enemy.previous_state = gv.fsm.state.name

#print(gv.enemy_fsm.estate.name)

#print(str(enemy.position.distance_to(gv.Hero_position)))

#enemy.velocity.y += enemy.gravity * delta
	#enemy.move_and_slide()
	
	#if enemy.somebody_hitme == true:
		
		
#	if enemy.is_on_floor():
#		estate_machine.transition_to("Idle")
#		get_node("../../snd_fall").play()











