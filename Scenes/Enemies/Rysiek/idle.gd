extends RysiekState

# #################
# # IDLE  .SCRIPT #
# #################

@onready var ray_cast:RayCast2D = get_node("../../PlayerCast2D")
@onready var But_L_spr:Sprite2D = get_node("../../CanvasGroup/Noga_L/But_L")
@onready var But_P_spr:Sprite2D = get_node("../../CanvasGroup/Noga_P/But_P")


signal first_hero_catch

func enter(_msg := {}) -> void:
	rysiek.velocity = Vector2.ZERO
	get_node("../../snd_walk").stop()
	#get_node("../../snd_fall").stop()
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("idle")
	print("rysiek fsm: IDLE")
		
 
@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:
	
	rysiek.velocity.y += rysiek.gravity * delta
	
	
	
	if not rysiek.is_on_floor():
		#rysiek.previous_state = gv.rysiek_fsm.rstate.name
		rstate_machine.transition_to("Air")
		return
		
	# GAME PAUSE:
	""" if gv.Game_pause == true:
		rysiek.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """


	# print("XXXXXXXXX: " + str(int(rysiek.global_position.distance_to(gv.Hero_global_position))))
		

	# TURN LEFT: player is on left side
	# if gv.Hero_global_position.x + rysiek.change_direction_distance < rysiek.global_position.x:
	if gv.Player.global_position.x < rysiek.global_position.x:
		if rysiek.Enemy_direction == Vector2.RIGHT:	
			rysiek.scale.x = rysiek.scale.y * 1
			rysiek.Enemy_direction = Vector2.LEFT
	
	# TURN RIGHT: player is on right side
	if gv.Player.global_position.x > rysiek.global_position.x:
		if rysiek.Enemy_direction == Vector2.LEFT:
			rysiek.scale.x = rysiek.scale.y * -1
			rysiek.Enemy_direction = Vector2.RIGHT
	
	# SEE PLAYER:					
	if 	rysiek.see_Player == true:		
		if rysiek.first_hero_catch == false:
			#emit_signal("first_hero_catch")
			rysiek.first_hero_catch = true

			# This rysiek cloud say information:
			rysiek.chat_instance = rysiek.Chat.instantiate()
			rysiek.chat_instance.Say("Eeeee ty \ncwaniaczku !!!",6,0,220)
			rysiek.get_tree().root.add_child(rysiek.chat_instance)
			#rysiek.chat_instance.connect('early_hit', _on_bomb_early_hit)
			print("rysiek: First time see profesor")

			# PAUSE:
			# get_tree().paused = true

			#get_node("../../snd_first_see").play()
			
	# ESCAPE:		
	""" if rysiek.global_position.distance_to(gv.Hero_global_position) <= rysiek.contact_distance:
		#if get_node("../../Say").visible == false:
		if rysiek.direction == "R":
			rysiek.previous_state = gv.enemy_fsm.estate.name
			estate_machine.transition_to("Walk_Left")
		if rysiek.direction == "L":
			rysiek.previous_state = gv.enemy_fsm.estate.name
			estate_machine.transition_to("Walk_Right")	 """

	# Atack1:		
	""" if rysiek.global_position.distance_to(gv.Hero_global_position) <= rysiek.Atack1_distance and rysiek.global_position.distance_to(gv.Hero_global_position) > rysiek.Atack1_distance/2: 
		#if get_node("../../Say").visible == false:
		if rysiek.direction == "R":
			rysiek.previous_state = gv.enemy_fsm.estate.name
			print("enemy2: Atack jump right")
			estate_machine.transition_to("Jump_right")
		if rysiek.direction == "L":
			rysiek.previous_state = gv.enemy_fsm.estate.name
			print("enemy2: Atack jump left")
			estate_machine.transition_to("Jump_left")	 """		
					
	# WALK LEFT				
	# if rysiek.global_position.distance_to(gv.Hero_global_position) >= rysiek.follow_distance:
	# 	#if get_node("../../Say").visible == false:
	# 	if rysiek.direction == "R":
	# 		rysiek.previous_state = gv.enemy_fsm.estate.name
	# 		estate_machine.transition_to("Walk_Right")
	# 	if rysiek.direction == "L":
	# 		rysiek.previous_state = gv.enemy_fsm.estate.name
	# 		estate_machine.transition_to("Walk_Left")
		
	
	rysiek.move_and_slide()
	
	But_L_spr.rotation = rysiek.get_floor_angle()
	But_P_spr.rotation = rysiek.get_floor_angle()

	
func _on_enemy_somebody_hitme() -> void:
	if gv.rysiek_fsm.rstate.name != "Hit":
		rysiek.previous_state = gv.rysiek_fsm.rstate.name
	rstate_machine.transition_to("Hit")
		


	##################### :)
	# 	   .-"-.
	#    _/.-.-.\_
	#   ( ( o o ) )
	#    |/  "  \|
	#     \'/^\'/
	#     /`\ /`\
	#    /  /|\  \
	#   ( (/ T \) )
	#    \__/^\__/


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
