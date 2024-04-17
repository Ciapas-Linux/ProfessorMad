extends PlayerState

@onready var footR_CollisionShape2D : CollisionShape2D = get_node("../../footR_CollisionShape2D")
@onready var footL_CollisionShape2D : CollisionShape2D = get_node("../../footL_CollisionShape2D")



func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	footR_CollisionShape2D.set_deferred("disabled", true)
	footL_CollisionShape2D.set_deferred("disabled", true)

func physics_update(delta: float) -> void:
	# if not player.is_on_floor():
	# 	state_machine.transition_to("Air")
	# 	return
		
	if gv.Hero_is_paused == true:
		state_machine.transition_to("Idle")
		return		

	# var input_direction_x: float = (
	# 	Input.get_action_strength("ui_right")
	# 	- Input.get_action_strength("ui_left")
	# )
	
	
	#input_direction_x = gv.Hero_direction.x

	get_node("../../AnimationPlayer").play("run")
		
	if get_node("../../snd_walk").playing != true:
			get_node("../../snd_walk").play()


	if Input.is_action_just_pressed("ui_up"):
		state_machine.transition_to("Air_run", {do_jump = true})
	# elif is_equal_approx(input_direction_x, 0.0):
	# 	state_machine.transition_to("Idle")

	player.velocity.x = player.speed_run * gv.Hero_direction.x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	
	if Input.is_action_just_released("run"):
		state_machine.transition_to("Idle")