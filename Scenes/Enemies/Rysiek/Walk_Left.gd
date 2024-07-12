extends RysiekState

# #####################
# # WALK LEFT.SCRIPT  #
# #####################


var distance_to_Player:float

var ray_normal:Vector2
var offset: float
var floor_normal:Vector2

func enter(_msg := {}) -> void:
	rysiek.anim_player.stop()
	rysiek.scale.x = rysiek.scale.y * 1
	rysiek.Enemy_direction = Vector2.LEFT
	rysiek.anim_player.play("walk")
	print("Rysiek state: Walk_left")
	

# Exit state:	
func exit() -> void:
	print("Rysiek state: Exit Walk_left state")
	gv.rysiek_fsm.previous_state = "Walk_left"


#@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:
	rysiek.velocity.x = -rysiek.speed
	rysiek.velocity.y += rysiek.gravity * delta
	distance_to_Player = rysiek.global_position.distance_to(gv.Player.global_position)

	# GAME PAUSE:
	""" if gv.Game_pause == true:
		rysiek.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """
	
	if get_node("../../snd_walk").playing != true:
			get_node("../../snd_walk").play()
			
	if distance_to_Player < rysiek.contact_distance + 500:
		# if gv.Hero_pos_x + rysiek.change_direction_distance < rysiek.position.x:
		# 	rysiek.scale.x = rysiek.scale.y * 1
		# 	rysiek.direction = "L"
		# if gv.Hero_pos_x - rysiek.change_direction_distance > rysiek.position.x:
		# 	rysiek.scale.x = rysiek.scale.y * -1
		# 	rysiek.direction = "R"

		rysiek.anim_player.stop()
		#rysiek.previous_state = gv.enemy_fsm.estate.name
		rstate_machine.transition_to("Walk_Right")		

#	if rysiek.see_Player == true:
#		get_node("../../AnimationPlayer").stop()
#		rysiek.previous_state = gv.enemy_fsm.estate.name
#		estate_machine.transition_to("idle")
		
#	if rysiek.position.distance_to(gv.Hero_global_position) > 500:
#		rysiek.previous_state = gv.enemy_fsm.estate.name
#		get_node("../../AnimationPlayer").stop()
#		estate_machine.transition_to("idle")
	
			
	rysiek.move_and_slide()

	# -= AHTUNG =- !!! :
	# Rotate foot to match slope angle:
	if rysiek.is_on_floor() and rysiek.SlopeRayCast.is_colliding():
		offset = deg_to_rad(90)
		ray_normal =  rysiek.SlopeRayCast.get_collision_normal()
		rysiek.Rysiek_tilt = (int)(rad_to_deg(ray_normal.angle() + offset ) * -1)
		
		#print("Rysiek tilt:" + str(rysiek.Rysiek_tilt))	

		# No slope:
		if rysiek.Rysiek_tilt < 10 and rysiek.Rysiek_tilt > -10:
			if rysiek.anim_player.get_current_animation() != "walk":
				rysiek.anim_player.play("walk")
				rysiek.anim_player.seek(0.3,true)
			rysiek.But_R_spr.rotation = ray_normal.angle() + offset
			rysiek.But_L_spr.rotation = ray_normal.angle() + offset
			rysiek.Rysiek_up_down = 0	# flat = 0
			#get_node("../../CollisionShape2D").shape.height = 700	
		
		# Slope:
		elif rysiek.Rysiek_tilt > 10 or rysiek.Rysiek_tilt < -10:
			if rysiek.anim_player.get_current_animation() != "walk":
				rysiek.anim_player.play("walk")

			if rysiek.Rysiek_tilt < 0:
				if rysiek.Enemy_direction == Vector2.RIGHT: # going DOWN: 2
					rysiek.But_R_spr.rotation = -(ray_normal.angle() + offset)
					rysiek.But_L_spr.rotation = -(ray_normal.angle() + offset)
					#print("Rysiek tilt DOWN:" + str(rysiek.Rysiek_tilt))
					#get_node("../../CollisionShape2D").shape.height = 730
					rysiek.Rysiek_up_down = 2
				if rysiek.Enemy_direction == Vector2.LEFT: # going UP: 1
					rysiek.But_R_spr.rotation = ray_normal.angle() + offset
					rysiek.But_L_spr.rotation = ray_normal.angle() + offset
					#print("Rysiek tilt UP:" + str(rysiek.Rysiek_tilt))
					#get_node("../../CollisionShape2D").shape.height = 600	
					rysiek.Rysiek_up_down = 1

			if rysiek.Rysiek_tilt > 0:
				if rysiek.Enemy_direction == Vector2.RIGHT: # going UP:
					rysiek.But_R_spr.rotation = -(ray_normal.angle() + offset)
					rysiek.But_L_spr.rotation = -(ray_normal.angle() + offset)
					#print("Rysiek tilt UP:" + str(rysiek.Rysiek_tilt))
					#get_node("../../CollisionShape2D").shape.height = 600	
					rysiek.Rysiek_up_down = 1
				if rysiek.Enemy_direction == Vector2.LEFT: # going DOWN:
					#print("Rysiek tilt DOWN:" + str(rysiek.Rysiek_tilt))
					rysiek.But_R_spr.rotation = ray_normal.angle() + offset
					rysiek.But_L_spr.rotation = ray_normal.angle() + offset
					# get_node("../../CollisionShape2D").shape.height = 730	
					rysiek.Rysiek_up_down = 2


	if rysiek.is_on_wall():	
		rysiek.anim_player.stop()
		print("Rysiek: stop on wall going left")
		print("Rysiek: trying jump over wall")
		rstate_machine.transition_to("Jump_left")

	if rysiek.is_on_floor() == false:
		rstate_machine.transition_to("Air")		