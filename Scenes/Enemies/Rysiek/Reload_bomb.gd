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
	print("rysiek fsm: RELOAD BOMB...")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "reload_bomb":
		rysiek.previous_state = gv.enemy_fsm.estate.name
		rstate_machine.transition_to("idle")
