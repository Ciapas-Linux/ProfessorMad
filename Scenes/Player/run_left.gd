extends PlayerState

func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	if gv.Hero_is_paused == true:
		state_machine.transition_to("Idle")
		return		

	var input_direction_x: float = (
		Input.get_action_strength("ui_right")
		- Input.get_action_strength("ui_left")
	)
	player.velocity.x = player.speed_run * input_direction_x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	get_node("../../AnimationPlayer2").play("run")
		
	if get_node("../../snd_walk").playing != true:
			get_node("../../snd_walk").play()

	if Input.is_action_just_pressed("ui_up"):
		state_machine.transition_to("Air_run", {do_jump = true})
	elif is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")
