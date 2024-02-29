extends PlayerState


func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("Hit_bomb2")
	print("Hero: enter state machine hit bomb!")
	get_node("../../BloodSplash").visible = true
	get_node("../../BloodSplash").emitting = true
	get_node("../../snd_hit1").play()
	
@warning_ignore("unused_parameter")
func physics_update(delta: float) -> void:
	pass

func _on_player_bomb_hit_me() -> void:
	pass # Replace with function body.

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "Hit_bomb2":
		state_machine.transition_to("Idle")
