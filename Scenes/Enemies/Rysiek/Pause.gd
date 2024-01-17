extends EnemyState

# ####################
# # PAUSE    .SCRIPT #
# ####################

func enter(_msg := {}) -> void:
	print("enemy fsm: PAUSE")

@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:
	pass

	if gv.Game_pause == false:
		#enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to(enemy.previous_state)
		