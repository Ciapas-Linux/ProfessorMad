extends RysiekState

# ####################
# # AIR      .SCRIPT #
# ####################

func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	print("Rysiek state: Air")

# Exit state:	
func exit() -> void:
	#gv.rysiek_fsm.previous_state = "Air"
	print("Rysiek state: Exit Air state")

@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:

	# GAME PAUSE:
	""" if gv.Game_pause == true:
		#rysiek.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """

	rysiek.velocity.y += rysiek.gravity * delta
	rysiek.move_and_slide()

	if rysiek.is_on_floor():
		state_machine.transition_to("idle")
		get_node("../../snd_fall").play()
