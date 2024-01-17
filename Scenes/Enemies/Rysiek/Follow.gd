extends EnemyState

# #####################
# # FOLLOW LEFT       #
# #####################

signal first_hero_catch


@onready var ray_cast:RayCast2D = get_node("../../PlayerCast2D")

func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	enemy.scale.x = enemy.scale.y * 1
	get_node("../../AnimationPlayer").play("walk")
	print("enemy fsm: FOLLOW LEFT")
	pass

func _process(_delta: float) -> void:
	pass

@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:

	# GAME PAUSE:
	""" if gv.Game_pause == true:
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """

	enemy.velocity.x = -enemy.speed
	enemy.velocity.y += enemy.gravity * delta
	
	enemy.move_and_slide()
	
	
	if ray_cast.is_colliding():
		if ray_cast.get_collider().name == "Player":
			print("enemy: ray hit Player")
			enemy.player_collision_point = ray_cast.get_collision_point()
			print("enemy: distance to player --> " + 
			str(int(enemy.position.distance_to
			(enemy.player_collision_point))))
			
			enemy.previous_state = gv.enemy_fsm.estate.name
			get_node("../../AnimationPlayer").stop()
			if enemy.first_hero_catch == false:
				emit_signal("first_hero_catch")
				enemy.first_hero_catch = true
				print("enemy: First time see profesor")
			else:
				print("enemy: me see profesor")	
			estate_machine.transition_to("idle")
						
		else:
			print("enemy: ray hit --> " + ray_cast.get_collider().name)	
		
		
				
	if enemy.is_on_wall():	
		enemy.previous_state = gv.enemy_fsm.estate.name
		get_node("../../AnimationPlayer").stop()
		print("enemy2: stop on wall going left")
		estate_machine.transition_to("Jump_left")		
		
		
			
	
func _on_enemy_somebody_hitme() -> void:
	if gv.enemy_fsm.estate.name != "Hit":
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Hit")










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
