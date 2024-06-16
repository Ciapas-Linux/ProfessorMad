extends PlayerState

func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	get_node("../../AnimationPlayer").play("run")
	get_node("../../AnimationPlayer").seek(0.3)
	if get_node("../../snd_walk").playing != true:
			get_node("../../snd_walk").play()

func physics_update(delta: float) -> void:
	# if not player.is_on_floor():
	# 	state_machine.transition_to("Air")
	# 	return
	
	if gv.Hero_is_paused == true:
		state_machine.transition_to("Idle")
		return		
	
	player.velocity.x = player.speed_run * gv.Hero_direction.x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if Input.is_action_just_pressed("ui_up"):
		state_machine.transition_to("Air_run", {do_jump = true})
	
	if Input.is_action_just_released("run"):
		state_machine.transition_to("Idle")








# elif is_equal_approx(input_direction_x, 0.0):
	# 	state_machine.transition_to("Idle")