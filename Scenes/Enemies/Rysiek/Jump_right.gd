extends EnemyState

# #####################
# # JUMP RIGHT.SCRIPT #
# #####################

var stop:bool = false

func enter(_msg := {}) -> void:
	enemy.velocity.y = - enemy.jump_impulse
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("Jump")
	if get_node("../../snd_jump").playing != true:
		get_node("../../snd_jump").play()
	print("enemy fsm: JUMP RIGHT")
	
@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:

	# GAME PAUSE:
	""" if gv.Game_pause == true:
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """
				
	enemy.velocity.x = enemy.speed + 100
	enemy.velocity.y += enemy.gravity * delta
	
	#if stop == false:
	enemy.move_and_slide()
		
	if enemy.is_on_floor_only():
	#if stop == false:
		if get_node("../../snd_fall").playing != true:
			get_node("../../snd_fall").play()
		get_node("../../AnimationPlayer").stop()
		get_node("../../AnimationPlayer").play("idle")	
		print("enemy: Jump_right to floor")
		# await get_tree().create_timer(0.5).timeout
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("idle")
	
	
