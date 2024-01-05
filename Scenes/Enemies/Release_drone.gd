extends EnemyState

# #####################
# # RELEASE DRONE     #
# #####################

func enter(_msg := {}) -> void:
	enemy.velocity = Vector2.ZERO
	#get_node("../../snd_walk").stop()
	#get_node("../../snd_fall").stop()
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("release_drone")
	get_node("../../snd_release_drone").play()
	print("enemy fsm: RELEASE DRONE...")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "release_drone":
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("idle")
		
