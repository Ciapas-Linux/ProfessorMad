
extends RysiekState


# ####################
# # ATACK     SCRIPT #
# ####################

func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("Atack1")
	if get_node("../../snd_atack1").playing != true:
		get_node("../../snd_atack1").play()
	print("Rysiek state: Atack")
	

# Exit state:	
func exit() -> void:
	gv.rysiek_fsm.previous_state = "Atack"

func physics_update(_delta: float) -> void:
	pass	
