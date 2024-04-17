extends PlayerState

var walk = false
var walk_speed  
@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer")


func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	walk_speed = player.speed/2
	
	if get_node("../../snd_sit").playing != true:
			get_node("../../snd_sit").play()	
	
	get_node("../../snd_walk").stop()
	get_node("../../snd_fall").stop()
	
	#anim_player.stop()
	if gv.Hero_current_weapon == 2:
		anim_player.play("target_up_rpg")
	else:
		anim_player.play("target_up")
	#get_node("../../AnimationPlayer").connect("finished",_on_fire_finished)

	if gv.Hero_weapon.is_connected("fire", _on_gun_2_fire) == false:
		gv.Hero_weapon.connect("fire", _on_gun_2_fire)
		

func _on_animation_player_2_animation_finished(_anim_name:StringName) -> void:
	if gv.Hero_current_weapon == 0:
		await get_tree().create_timer(1.0).timeout
		#state_machine.transition_to("Idle")


#func _on_fire_finished() -> void:
	#get_node("../../AnimationPlayer").play("target_up")


func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	if gv.Hero_is_paused == true:
		state_machine.transition_to("Idle")
		return

	if Input.is_action_just_pressed("Reload"):
		gv.Hero_weapon.reload()
		print("Player: reload weapon")			
				
	if Input.is_action_pressed("ui_right"):
		gv.Hero_direction = Vector2.RIGHT
		player.velocity.x = walk_speed
		walk = true
		#print_debug(walk) 
	
	# walk backward
	if Input.is_action_pressed("ui_left"):
		#gv.Hero_direction = Vector2.LEFT
		player.velocity.x = -walk_speed
		walk = true	
	
	if Input.is_action_just_released("ui_right"):		
		walk = false
		player.velocity.x = 0
		anim_player.stop()
		get_node("../../snd_walk").stop()
		#print_debug(walk) 
		#print_debug("release key right") 
		
	if Input.is_action_just_released("ui_left"):		
		walk = false
		player.velocity.x = 0
		anim_player.stop()
		get_node("../../snd_walk").stop()		

#	
	if walk == true:
		anim_player.play("target_up_walk")
		if get_node("../../snd_walk").playing != true:
			get_node("../../snd_walk").play()			
		
	
	if Input.is_action_just_pressed("ui_up"):
		state_machine.transition_to("Idle")

	if Input.is_action_just_pressed("ui_down"):
		state_machine.transition_to("Idle")	

	player.velocity.y += player.gravity * delta
	player.move_and_slide()


func _on_gun_2_fire() -> void:
	if gv.fsm.state.name == "target_up":
		if player.turn == true:
			player.position.x -= 3
		else:	
			player.position.x += 3






""" func _one_shot_timer_example():
	print("timer start")
	await get_tree().create_timer(1.0).timeout
	print("timer end") """

