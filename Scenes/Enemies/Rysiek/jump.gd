extends EnemyState

# ####################
# # AIR      .SCRIPT #
# ####################

func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	print("enemy fsm: AIR")

@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:

	# GAME PAUSE:
	""" if gv.Game_pause == true:
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """

	enemy.velocity.y += enemy.gravity * delta
	enemy.move_and_slide()

	if enemy.is_on_floor():
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("idle")
		get_node("../../snd_fall").play()
