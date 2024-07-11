extends RysiekState

# ####################
# # PAUSE    .SCRIPT #
# ####################

func enter(_msg := {}) -> void:
	print("Rysiek state: Pause")

# Exit state:	
func exit() -> void:
	gv.rysiek_fsm.previous_state = "Pause"

@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:
	pass

	if gv.Game_pause == false:
		#rysiek.previous_state = gv.rysiek_fsm.rstate.name
		rstate_machine.transition_to(rysiek.previous_state)
		