extends PlayerState


@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer")

func enter(msg := {}) -> void:

	if msg.has("back_area"):
		# if gv.Hero_direction == Vector2.LEFT:
		# 	anim_player.play("ass1")
		# if gv.Hero_direction == Vector2.RIGHT:
		# 	anim_player.play("ass2")
		anim_player.play("shockwave_back")
		pass

	if msg.has("front_area"):
		# if gv.Hero_direction == Vector2.LEFT:
		# 	anim_player.play("shockwave_back")	
		# if gv.Hero_direction == Vector2.RIGHT:
		# 	anim_player.play("shockwave_back")
		anim_player.play("shockwave_back")			

	gv.Hero_weapon.visible = false
	
	print("Player: enter state machine shockwave!")
	get_node("../../snd_hit2").play()
	

func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	if gv.Hero_direction == Vector2.LEFT:
		player.velocity.x = player.speed
	if gv.Hero_direction == Vector2.RIGHT:
		player.velocity.x = -player.speed	
	player.move_and_slide()


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "shockwave_back":
		gv.Hero_weapon.visible = true
		player.fade_in()
		state_machine.transition_to("Idle")
