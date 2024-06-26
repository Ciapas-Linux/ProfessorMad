extends RysiekState


func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("Hit_rpg")
	print("Enemy: enter state machine hit rpg!")
		
func physics_update(delta: float) -> void:
	rysiek.velocity.y += rysiek.gravity * delta
	if rysiek.rysiek_direction == Vector2.LEFT:
		rysiek.velocity.x = rysiek.speed
	if rysiek.rysiek_direction == Vector2.RIGHT:
		rysiek.velocity.x = -rysiek.speed	
	rysiek.move_and_slide()
	
func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "Hit_rpg":
		await get_tree().create_timer(1.0).timeout
		gv.rysiek_fsm.transition_to("idle")
	
