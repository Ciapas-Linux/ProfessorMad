extends RysiekState

# ####################
# # DEATH .SCRIPT #
# ####################

func enter(_msg := {}) -> void:
	print("enemy fsm: THEY KILL ME")
	

@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:
	pass	
