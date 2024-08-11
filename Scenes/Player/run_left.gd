extends PlayerState

@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer")


func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").play("run")
	get_node("../../AnimationPlayer").seek(0.3)
	if get_node("../../snd_walk").playing != true:
			get_node("../../snd_walk").play()
	anim_player.stop()
	print("Player: previous state " + player.Player_fsm.previous_state)			
	print("Player state: " + self.name)

func physics_update(delta: float) -> void:
	if anim_player.get_current_animation() != "run":
				anim_player.play("run")
				anim_player.seek(0.3)	
	
	if player.Player_is_paused == true:
		state_machine.transition_to("Idle")
		return		
	
	player.velocity.x = player.speed_run * player.Player_direction.x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if Input.is_action_just_pressed("ui_up"):
		state_machine.transition_to("Air_run", {do_jump = true})
	
	if Input.is_action_just_released("run"):
		state_machine.transition_to("Idle")








# elif is_equal_approx(input_direction_x, 0.0):
	# 	state_machine.transition_to("Idle")