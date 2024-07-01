extends PlayerState

@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer")
@onready var snd_fall : AudioStreamPlayer = get_node("../../snd_fall")


# AIR

func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = - player.jump_impulse_run
		get_node("../../snd_walk").stop()
		get_node("../../snd_jump").play()
		#get_node("../../AnimationPlayer").stop()
		get_node("../../AnimationPlayer").play("jump")
		gv.Hero_is_on_floor = false
		player.Foot_R.rotation = deg_to_rad(85)
		player.Foot_L.rotation = deg_to_rad(85)
				
		
func physics_update(delta: float) -> void:
	
	if player.is_on_floor():
		if gv.Hero_is_paused == true:
			state_machine.transition_to("Idle")
			return	
	
	if Input.is_action_pressed("ui_right"):
		#gv.Hero_direction = Vector2.RIGHT
		player.velocity.x = player.speed_run
	
	if Input.is_action_pressed("ui_left"):
		#gv.Hero_direction = Vector2.LEFT
		player.velocity.x = -player.speed_run	
	
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
		
	if player.is_on_floor() == true:
		anim_player.play("touch_down")
		#get_node("../../snd_fall").play()
		state_machine.transition_to("Idle")
		snd_fall.play()
				

