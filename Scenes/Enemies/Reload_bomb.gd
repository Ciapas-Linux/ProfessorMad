extends EnemyState

# #####################
# # RELOAD BOMB       #
# #####################

func enter(_msg := {}) -> void:
	enemy.velocity = Vector2.ZERO
	#get_node("../../snd_walk").stop()
	#get_node("../../snd_fall").stop()
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("reload_bomb")
	get_node("../../snd_release_drone").play()
	print("enemy fsm: RELOAD BOMB...")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "reload_bomb":
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("idle")
