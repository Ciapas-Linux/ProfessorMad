extends RysiekState

# #################
# # IDLE  .SCRIPT #
# #################

@onready var ray_cast:RayCast2D = get_node("../../PlayerCast2D")

var ray_normal:Vector2
var offset: float
var floor_normal:Vector2

signal first_hero_catch

func enter(_msg := {}) -> void:
	rysiek.velocity = Vector2.ZERO
	get_node("../../snd_walk").stop()
	#get_node("../../snd_fall").stop()
	rysiek.anim_player.stop()
	rysiek.anim_player.play("idle")

	print("Rysiek enter state: Idle")
	print("Rysiek previous state: " + rysiek.Rysiek_fsm.previous_state)
			
 
# Exit state:	
func exit() -> void:
	#gv.rysiek_fsm.previous_state = "idle"
	print("Rysiek state: Exit idle state")
	
func physics_update(delta: float) -> void:

	if not rysiek.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	rysiek.velocity.y += rysiek.gravity * delta
	rysiek.move_and_slide()

	# -= AHTUNG =- !!! :
	# Rotate foot to match slope angle:
	if rysiek.is_on_floor() and rysiek.SlopeRayCast.is_colliding():
		offset = deg_to_rad(90)
		ray_normal =  rysiek.SlopeRayCast.get_collision_normal()
		rysiek.Rysiek_tilt = (int)(rad_to_deg(ray_normal.angle() + offset ) * -1)
		
		#print("Rysiek tilt:" + str(rysiek.Rysiek_tilt))	

		# No slope:
		if rysiek.Rysiek_tilt < rysiek.slope_angle and rysiek.Rysiek_tilt > -rysiek.slope_angle:
			if rysiek.anim_player.get_current_animation() != "idle":
				rysiek.anim_player.play("idle")
				rysiek.anim_player.seek(0.3,true)
			rysiek.But_R_spr.rotation = ray_normal.angle() + offset
			rysiek.But_L_spr.rotation = ray_normal.angle() + offset
			rysiek.Rysiek_up_down = 0	# flat = 0
			#get_node("../../CollisionShape2D").shape.height = 700	
		
		# Slope:
		elif rysiek.Rysiek_tilt > rysiek.slope_angle or rysiek.Rysiek_tilt < -rysiek.slope_angle:
			if rysiek.anim_player.get_current_animation() != "idle":
				rysiek.anim_player.play("idle")

			if rysiek.Rysiek_tilt < 0:
				if rysiek.Enemy_direction == Vector2.RIGHT: # going DOWN: 2
					rysiek.But_R_spr.rotation = ray_normal.angle() + offset
					rysiek.But_L_spr.rotation = ray_normal.angle() + offset
					#get_node("../../CollisionShape2D").shape.height = 730
					rysiek.Rysiek_up_down = 2
				if rysiek.Enemy_direction == Vector2.LEFT: # going UP: 1
					rysiek.But_R_spr.rotation = -(ray_normal.angle() + offset)
					rysiek.But_L_spr.rotation = -(ray_normal.angle() + offset)
					#get_node("../../CollisionShape2D").shape.height = 600	
					rysiek.Rysiek_up_down = 1

			if rysiek.Rysiek_tilt > 0:
				if rysiek.Enemy_direction == Vector2.RIGHT: # going UP:
					rysiek.But_R_spr.rotation = -(ray_normal.angle() + offset)
					rysiek.But_L_spr.rotation = -(ray_normal.angle() + offset)
					#get_node("../../CollisionShape2D").shape.height = 600	
					rysiek.Rysiek_up_down = 1
				if rysiek.Enemy_direction == Vector2.LEFT: # going DOWN:
					# print("Rysiek tilt:" + str(rysiek.Rysiek_tilt))
					rysiek.But_R_spr.rotation = ray_normal.angle() + offset
					rysiek.But_L_spr.rotation = ray_normal.angle() + offset
					# get_node("../../CollisionShape2D").shape.height = 730	
					rysiek.Rysiek_up_down = 2
	
	
		
	# GAME PAUSE:
	""" if gv.Game_pause == true:
		rysiek.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """


	# print("XXXXXXXXX: " + str(int(rysiek.global_position.distance_to(gv.Hero_global_position))))
		

	# TURN LEFT: if player is on left side
	# if gv.Hero_global_position.x + rysiek.change_direction_distance < rysiek.global_position.x:
	if gv.Player.global_position.x < rysiek.global_position.x:
		if rysiek.Enemy_direction == Vector2.RIGHT:	
			rysiek.turn_left()
	
	# TURN RIGHT: if player is on right side
	if gv.Player.global_position.x > rysiek.global_position.x:
		if rysiek.Enemy_direction == Vector2.LEFT:
			rysiek.turn_right()
	
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
					
	# WALK LEFT:				
	if rysiek.global_position.distance_to(gv.Player.global_position) >= rysiek.follow_distance:
		#if get_node("../../Say").visible == false:
		if rysiek.Enemy_direction == Vector2.RIGHT:
			state_machine.transition_to("Walk_Right")
		if rysiek.Enemy_direction == Vector2.LEFT:
			state_machine.transition_to("Walk_Left")
			
func _on_enemy_somebody_hitme() -> void:
	if rysiek.Rysiek_fsm.rstate.name == "idle":
	# if gv.rysiek_fsm.rstate.name != "Hit":
	# 	rysiek.previous_state = gv.rysiek_fsm.rstate.name
		state_machine.transition_to("Hit")
		















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
