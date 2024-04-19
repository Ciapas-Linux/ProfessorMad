
extends RysiekState


# ####################
# # ATACK     SCRIPT #
# ####################

func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("Atack1")
	if get_node("../../snd_atack1").playing != true:
		get_node("../../snd_atack1").play()
	print("enemy fsm: DIRECT ATTACK")
	

@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:
	pass	
