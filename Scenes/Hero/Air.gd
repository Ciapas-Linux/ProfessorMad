extends PlayerState

# AIR

func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = - player.jump_impulse
		get_node("../../snd_walk").stop()
		get_node("../../snd_jump").play()
		get_node("../../AnimationPlayer").stop()
		get_node("../../AnimationPlayer").play("jump")
		gv.Hero_is_on_floor = false
				
		#if get_node("../../snd_walk").playing != true:
			#get_node("../../snd_walk").play()	
		

func physics_update(delta: float) -> void:
	
	if player.is_on_floor():
		if gv.Hero_is_paused == true:
			state_machine.transition_to("Idle")
			return	
	
	if Input.is_action_pressed("ui_right"):
		#gv.Hero_direction = Vector2.RIGHT
		player.velocity.x = player.speed
	
	if Input.is_action_pressed("ui_left"):
		#gv.Hero_direction = Vector2.LEFT
		player.velocity.x = -player.speed	
	
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
		
	if player.is_on_floor():
		state_machine.transition_to("Idle")
		get_node("../../snd_fall").play()
		
			
