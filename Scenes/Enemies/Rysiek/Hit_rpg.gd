extends EnemyState


func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("Hit_rpg")
	print("Enemy: enter state machine hit rpg!")
	#get_node("../../BloodSplash").visible = true
	#get_node("../../BloodSplash").emitting = true
	#get_node("../../snd_hit1").play()
	

func physics_update(_delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "Hit_rpg":
		gv.enemy_fsm.transition_to("idle")