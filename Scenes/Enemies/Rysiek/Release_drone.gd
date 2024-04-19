extends RysiekState

# #####################
# # RELEASE DRONE     #
# #####################

func enter(_msg := {}) -> void:
	rysiek.velocity = Vector2.ZERO
	#get_node("../../snd_walk").stop()
	#get_node("../../snd_fall").stop()
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("release_drone")
	get_node("../../snd_release_drone").play()
	print("rysiek fsm: RELEASE DRONE...")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "release_drone":
		rysiek.previous_state = gv.rysiek_fsm.rstate.name
		rstate_machine.transition_to("idle")
		
