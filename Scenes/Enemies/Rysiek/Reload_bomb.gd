extends RysiekState

# #####################
# # RELOAD BOMB       #
# #####################

func enter(_msg := {}) -> void:
	rysiek.velocity = Vector2.ZERO
	#get_node("../../snd_walk").stop()
	#get_node("../../snd_fall").stop()
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("reload_bomb")
	get_node("../../snd_release_drone").play()
	print("Rysiek state: Reload_bomb")

# Exit state:	
func exit() -> void:
	gv.rysiek_fsm.previous_state = "Reload_bomb"

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "reload_bomb":
		#rysiek.previous_state = gv.rysiek_fsm.rstate.name
		rstate_machine.transition_to("idle")
