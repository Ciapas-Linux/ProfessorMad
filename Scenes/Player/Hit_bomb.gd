extends PlayerState


@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer2")
@onready var tween: Tween

func enter(_msg := {}) -> void:
	gv.Hero_weapon.visible = false
	anim_player.stop()
	#anim_player.play("Bomb_hit_me")
	print("Hero: enter state machine hit bomb!")
	get_node("../../BloodSplash").visible = true
	get_node("../../BloodSplash").emitting = true
	get_node("../../snd_hit1").play()
	_explode()

@warning_ignore("unused_parameter")
func physics_update(delta: float) -> void:
	pass

func _explode():
	tween = get_tree().create_tween()
	tween.connect("finished", on_tween_finished)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	
	var body_parts:Sprite2D

	body_parts = get_node("../../Body_parts/Head")
	tween.tween_property(body_parts, "global_rotation", randf_range(-5.0,5.0), 1.5)
	tween.tween_property(body_parts, "global_position", Vector2(player.global_position.x + randf_range(-105.0,105.0), player.global_position.y - randf_range(625.0,1235.0)), 1.6)
	tween.tween_property(body_parts, "self_modulate", Color(1, 0, 0, 0), 1.5)

	body_parts = get_node("../../Body_parts/Arm_L")
	tween.tween_property(body_parts, "global_rotation", randf_range(-5.0,5.0), 1.2)
	tween.tween_property(body_parts, "global_position", Vector2(player.global_position.x + randf_range(-405.0,505.0), player.global_position.y - randf_range(585.0,1005.0)), 1.7)
	tween.tween_property(body_parts, "self_modulate", Color(1, 1, 1, 0), 1.6)
	
	body_parts = get_node("../../Body_parts/Hand_L")
	tween.tween_property(body_parts, "global_rotation", randf_range(-5.0,5.0), 1.7)
	tween.tween_property(body_parts, "global_position", Vector2(player.global_position.x + randf_range(-475.0,575.0) , player.global_position.y - randf_range(585.0,805.0)), 1.8)
	tween.tween_property(body_parts, "self_modulate", Color(1, 1, 1, 0), 1.5)
	
	body_parts = get_node("../../Body_parts/Hand_L/ForeArm_L")
	tween.tween_property(body_parts, "global_rotation", randf_range(-5.0,5.0), 1.5)
	tween.tween_property(body_parts, "global_position", Vector2(player.global_position.x + randf_range(-475.0,475.0), player.global_position.y - randf_range(585.0,805.0)), 1.5)
	tween.tween_property(body_parts, "self_modulate", Color(1, 1, 1, 0), 1.6)
	
	body_parts = get_node("../../Body_parts/Leg_L")
	tween.tween_property(body_parts, "global_rotation", randf_range(-5.0,5.0), 1.2)
	tween.tween_property(body_parts, "global_position", Vector2(player.global_position.x + randf_range(-475.0,575.0), player.global_position.y - randf_range(585.0,905.0)), 1.4)
	tween.tween_property(body_parts, "self_modulate", Color(1, 1, 1, 0), 1.4)
	
	body_parts = get_node("../../Body_parts/Leg_L/Foot_L")
	tween.tween_property(body_parts, "global_rotation", randf_range(-5.0,5.0), 1.1)
	tween.tween_property(body_parts, "global_position", Vector2(player.global_position.x + randf_range(-475.0,575.0), player.global_position.y - randf_range(585.0,905.0)), 1.3)
	tween.tween_property(body_parts, "self_modulate", Color(1, 1, 1, 0), 1.4)
	
	body_parts = get_node("../../Body_parts/Leg_L/Foot_L/Calf_L")
	tween.tween_property(body_parts, "global_rotation", randf_range(-5.0,5.0), 1.5)
	tween.tween_property(body_parts, "global_position", Vector2(player.global_position.x + randf_range(-405.0,555.0), player.global_position.y - randf_range(585.0,905.0)), 1.3)
	tween.tween_property(body_parts, "self_modulate", Color(1, 1, 1, 0), 1.5)
	
	body_parts = get_node("../../Body_parts/Leg_R")
	tween.tween_property(body_parts, "global_rotation", randf_range(-5.0,5.0), 1.2)
	tween.tween_property(body_parts, "global_position", Vector2(player.global_position.x + randf_range(-495.0,595.0), player.global_position.y - randf_range(685.0,805.0)), 1.5)
	tween.tween_property(body_parts, "self_modulate", Color(1, 1, 1, 0), 1.3)
	
	body_parts = get_node("../../Body_parts/Leg_R/Foot_R")
	tween.tween_property(body_parts, "global_rotation", randf_range(-5.0,5.0), 2.1)
	tween.tween_property(body_parts, "global_position", Vector2(player.global_position.x + randf_range(-405.0,405.0), player.global_position.y - randf_range(585.0,735.0)), 1.3)
	tween.tween_property(body_parts, "self_modulate", Color(1, 1, 1, 0), 1.4)
	
	body_parts = get_node("../../Body_parts/Leg_R/Foot_R/Calf_R")
	tween.tween_property(body_parts, "global_rotation", randf_range(-5.0,5.0), 1.2)
	tween.tween_property(body_parts, "global_position", Vector2(player.global_position.x + randf_range(-405.0,505.0), player.global_position.y - randf_range(485.0,735.0)), 1.3)
	tween.tween_property(body_parts, "self_modulate", Color(1, 1, 1, 0), 1.3)
	
	body_parts = get_node("../../Body_parts/Body")
	tween.tween_property(body_parts, "global_rotation", randf_range(-5.0,5.0), 1.4)
	tween.tween_property(body_parts, "global_position", Vector2(player.global_position.x + randf_range(-405.0,505.0), player.global_position.y - randf_range(525.0,935.0)), 1.2)
	tween.tween_property(body_parts, "self_modulate", Color(1, 1, 1, 0), 1.6)
	
	body_parts = get_node("../../Body_parts/Arm_R")
	tween.tween_property(body_parts, "global_rotation", randf_range(-5.0,5.0), 1.9)
	tween.tween_property(body_parts, "global_position", Vector2(player.global_position.x + randf_range(-405.0,605.0), player.global_position.y - randf_range(525.0,835.0)), 1.6)
	tween.tween_property(body_parts, "self_modulate", Color(1, 1, 1, 0), 1.4)

	body_parts = get_node("../../Body_parts/Arm_R/Hand_R")
	tween.tween_property(body_parts, "global_rotation", randf_range(-5.0,5.0), 1.9)
	tween.tween_property(body_parts, "global_position", Vector2(player.global_position.x + randf_range(-405.0,605.0), player.global_position.y - randf_range(525.0,935.0)), 1.1)
	tween.tween_property(body_parts, "self_modulate", Color(1, 1, 1, 0), 1.6)

	body_parts = get_node("../../Body_parts/Arm_R/ForeArm_R")
	tween.tween_property(body_parts, "global_rotation", randf_range(-5.0,5.0), 2.2)
	tween.tween_property(body_parts, "global_position", Vector2(player.global_position.x + randf_range(-405.0,605.0), player.global_position.y - randf_range(525.0,835.0)), 1.3)
	tween.tween_property(body_parts, "self_modulate", Color(1, 1, 1, 0), 1.4)

	body_parts = get_node("../../Body_parts/Head/powieka_P")
	#tween.tween_property(body_parts, "global_rotation", randf_range(-5.0,5.0), 2.2)
	#tween.tween_property(body_parts, "global_position", Vector2(player.global_position.x + randf_range(-405.0,605.0), player.global_position.y - randf_range(325.0,635.0)), 1.6)
	tween.tween_property(body_parts, "self_modulate", Color(1, 1, 1, 0), 1.6)

	body_parts = get_node("../../Body_parts/Head/powieka_P")
	#tween.tween_property(body_parts, "global_rotation", randf_range(-5.0,5.0), 2.2)
	#tween.tween_property(body_parts, "global_position", Vector2(player.global_position.x + randf_range(-405.0,605.0), player.global_position.y - randf_range(325.0,635.0)), 1.3)
	tween.tween_property(body_parts, "self_modulate", Color(1, 1, 1, 0), 1.5)



func on_tween_finished():
	#if anim_name == "Bomb_hit_me":
	gv.Hero_weapon.visible = true
	player.fade_in()
	state_machine.transition_to("Idle")

func _on_player_bomb_hit_me() -> void:
	pass # Replace with function body.

func _on_animation_player_2_animation_finished(anim_name:StringName) -> void:
	# if anim_name == "Bomb_hit_me":
	# 	state_machine.transition_to("Idle")
	pass

