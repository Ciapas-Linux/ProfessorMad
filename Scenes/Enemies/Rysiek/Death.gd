extends RysiekState

# ####################
# # DEATH .SCRIPT #
# ####################

func enter(_msg := {}) -> void:
	print("Rysiek state: Death")
	

# Exit state:	
func exit() -> void:
	gv.rysiek_fsm.previous_state = "Death"

@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:
	pass	
