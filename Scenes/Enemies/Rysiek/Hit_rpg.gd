# @uid("uid://2o0thcli7xdf") # Generated automatically, do not modify.
extends EnemyState


func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("Hit_rpg")
	print("Enemy: enter state machine hit rpg!")
		

func physics_update(delta: float) -> void:
	enemy.velocity.y += enemy.gravity * delta
	if enemy.direction == "L":
		enemy.velocity.x = enemy.speed
	if enemy.direction == "P":
		enemy.velocity.x = -enemy.speed	
	enemy.move_and_slide()
	

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "Hit_rpg":
		await get_tree().create_timer(1.0).timeout
		gv.enemy_fsm.transition_to("idle")
	
