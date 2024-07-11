extends RysiekState

# #####################
# # FOLLOW LEFT       #
# #####################

signal first_hero_catch


@onready var ray_cast:RayCast2D = get_node("../../PlayerCast2D")

func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	rysiek.scale.x = rysiek.scale.y * 1
	get_node("../../AnimationPlayer").play("walk")
	print("Rysiek state: Follow")
	pass

# Exit state:	
func exit() -> void:
	gv.rysiek_fsm.previous_state = "Follow"

func _process(_delta: float) -> void:
	pass

@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:

	# GAME PAUSE:
	""" if gv.Game_pause == true:
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """

	rysiek.velocity.x = -rysiek.speed
	rysiek.velocity.y += rysiek.gravity * delta
	
	rysiek.move_and_slide()
		
	if ray_cast.is_colliding():
		if ray_cast.get_collider().name == "Player":
			print("rysiek: ray hit Player")
			rysiek.player_collision_point = ray_cast.get_collision_point()
			print("rysiek: distance to player --> " + 
			str(int(rysiek.position.distance_to
			(rysiek.player_collision_point))))
			
			#rysiek.previous_state = gv.rysiek_fsm.rstate.name
			get_node("../../AnimationPlayer").stop()
			if rysiek.first_hero_catch == false:
				emit_signal("first_hero_catch")
				rysiek.first_hero_catch = true
				print("rysiek: First time see profesor")
			else:
				print("rysiek: me see profesor")	
			rstate_machine.transition_to("idle")
						
		else:
			print("rysiek: ray hit --> " + ray_cast.get_collider().name)	
						
	if rysiek.is_on_wall():	
		get_node("../../AnimationPlayer").stop()
		print("enemy2: stop on wall going left")
		rstate_machine.transition_to("Jump_left")		
			
func _on_enemy_somebody_hitme() -> void:
	if gv.rysiek_fsm.rstate.name == "Follow_left":
		if gv.rysiek_fsm.rstate.name != "Hit":
			rstate_machine.transition_to("Hit")










# enemy.collision = enemy.get_last_slide_collision()
	# print("enemy collide with: " + enemy.collision.collider)
	
	#if enemy.position.distance_to(gv.Hero_position) < 600:
#		enemy.previous_state = gv.enemy_fsm.estate.name
#		get_node("../../AnimationPlayer").stop()
#		if enemy.first_hero_catch == false:
#			emit_signal("first_hero_catch")
#			enemy.first_hero_catch = true
#			print("enemy: First time see profesor")
#		else:
#			print("enemy: me see profesor")	
#		estate_machine.transition_to("idle")
		#pass
