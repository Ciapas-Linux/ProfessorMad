extends RysiekState


func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("Hit_rpg")
	print("Rysiek state: Hit_rpg")
		

# Exit state:	
func exit() -> void:
	gv.rysiek_fsm.previous_state = "Hit_rpg"


func physics_update(delta: float) -> void:
	rysiek.velocity.y += rysiek.gravity * delta
	if rysiek.Enemy_direction == Vector2.LEFT:
		rysiek.velocity.x = rysiek.speed
	if rysiek.Enemy_direction == Vector2.RIGHT:
		rysiek.velocity.x = -rysiek.speed	
	rysiek.move_and_slide()
	
func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "Hit_rpg":
		await get_tree().create_timer(1.0).timeout
		gv.rysiek_fsm.transition_to("idle")
	
# Enemy_direction