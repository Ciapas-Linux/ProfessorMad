extends RysiekState

# ####################
# # AIR      .SCRIPT #
# ####################

func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	print("rysiek fsm: AIR")

@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:

	# GAME PAUSE:
	""" if gv.Game_pause == true:
		rysiek.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """

	rysiek.velocity.y += rysiek.gravity * delta
	rysiek.move_and_slide()

	if rysiek.is_on_floor():
		#rysiek.previous_state = gv.rysiek_fsm.rstate.name
		rstate_machine.transition_to("idle")
		get_node("../../snd_fall").play()
