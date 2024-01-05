extends PlayerState

signal turn(value)


func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	get_node("../../snd_walk").stop()
	get_node("../../snd_fall").stop()
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("idle")
	gv.Hero_is_on_floor = true
	if gv.Hero_weapon.is_connected("fire", _on_gun_2_fire) == false:
		gv.Hero_weapon.connect("fire", _on_gun_2_fire)
	

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		gv.Hero_is_on_floor = false
		return
		
	if gv.Hero_is_paused == true:	
		return

	if Input.is_action_just_pressed("Weapon"):
		get_node("../../snd_switch_weapon").play()
		player.load_next_weapon()
		print("Player: switch weapon")

	if Input.is_action_just_pressed("Reload"):
		gv.Hero_weapon.reload()
		print("Player: reload weapon")

	if Input.is_action_just_pressed("ui_up"):
		state_machine.transition_to("Air", {do_jump = true})
	
	# input left
	if Input.is_action_pressed("ui_left"):
		if gv.Hero_is_paused == false:
			player.scale.x = player.scale.y * -1
			gv.Hero_direction = Vector2.LEFT
			state_machine.transition_to("Walk")
			turn.emit(false)  
	
	# input right
	if Input.is_action_pressed("ui_right"):
		if gv.Hero_is_paused == false:
			gv.Hero_direction = Vector2.RIGHT
			player.scale.x = player.scale.y * 1
			state_machine.transition_to("Walk")
			turn.emit(true)
		
		
	# RUN RIGHT:	
	if Input.is_action_pressed("run") and Input.is_action_pressed("ui_right"):
		state_machine.transition_to("run_right")
		player.scale.x = player.scale.y * 1
		gv.Hero_direction = Vector2.RIGHT
		
		
	# RUN LEFT:	
	if Input.is_action_pressed("run") and Input.is_action_pressed("ui_left"): 
		state_machine.transition_to("run_left")
		player.scale.x = player.scale.y * -1
		gv.Hero_direction = Vector2.LEFT
				
		
	# TO AIM:	
	if Input.is_action_pressed("Target"):
		state_machine.transition_to("target_up")
		#player.scale.x = player.scale.y * 1
		#gv.hero_sprite.set_flip_h(false) 
		
	# SIT DOWN:	
	if Input.is_action_pressed("ui_down"):
		state_machine.transition_to("target_down")
		#player.scale.x = player.scale.y * 1
		#gv.hero_sprite.set_flip_h(false)

	player.velocity.y += player.gravity * delta
	player.move_and_slide()	 		
		
func _on_gun_2_fire() -> void:
	if gv.fsm.state.name == "Idle":
		#get_node("../../AnimationPlayer").stop()
		#get_node("../../AnimationPlayer").play("RESET")
		if player.turn == true:
			player.position.x -= 3
		else:	
			player.position.x += 3
	
		
func _on_gun_2_fire_stop() -> void:
	if gv.fsm.state.name == "Idle":
		
		#get_node("../../AnimationPlayer").stop()
		#get_node("../../AnimationPlayer").play("idle")
		pass
		
		
		
	# print("ASSSSSSSSSS ---->" + name)	
		
		
		
		
		




