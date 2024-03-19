extends PlayerState

@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer")
@onready var snd_fall : AudioStreamPlayer = get_node("../../snd_fall")


# AIR

func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = - player.jump_impulse
		get_node("../../snd_walk").stop()
		get_node("../../snd_jump").play()
		anim_player.stop()
		anim_player.play("jump")
		gv.Hero_is_on_floor = false
				
		#if get_node("../../snd_walk").playing != true:
			#get_node("../../snd_walk").play()	
		

func physics_update(delta: float) -> void:
	
	if Input.is_action_pressed("ui_right"):
		#gv.Hero_direction = Vector2.RIGHT
		player.velocity.x = player.speed
	
	if Input.is_action_pressed("ui_left"):
		#gv.Hero_direction = Vector2.LEFT
		player.velocity.x = -player.speed	
	
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
		
	if player.is_on_floor():
		if gv.Hero_is_paused == true:
			state_machine.transition_to("Idle")
			return	
		anim_player.play("touch_down")
		state_machine.transition_to("Idle")
		snd_fall.play()
		
		
					


func _on_animation_player_2_animation_finished(_anim_name:StringName):
	#state_machine.transition_to("Idle")
	pass

