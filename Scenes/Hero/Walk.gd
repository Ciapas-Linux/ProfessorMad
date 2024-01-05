
#.#############>
#. WALK       #>
#.#############>

extends PlayerState

var timer:Timer

func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	timer = Timer.new()
	add_child(timer)
	timer.set_one_shot(true)
	timer.set_wait_time(5)
	timer.connect("timeout",  _timer_timeout)
	timer.start()
	

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	if gv.Hero_is_paused == true:
		state_machine.transition_to("Idle")
		return	

	var input_direction_x: float = (
		Input.get_action_strength("ui_right")
		- Input.get_action_strength("ui_left"))
		
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	
	#if player.is_on_wall():
		#print("Hero: stop on wall going: " + str(input_direction_x))
		
	
	player.move_and_slide()
			
	get_node("../../AnimationPlayer").play("walk")
			
	if get_node("../../snd_walk").playing != true:
			get_node("../../snd_walk").play()	

	if Input.is_action_just_pressed("ui_up"):
		state_machine.transition_to("Air", {do_jump = true})
	elif is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")

func _timer_timeout():
	#print("Hero Walk fsm: Timeout test pass ")
	pass


# await get_tree().create_timer(1000).timeout
