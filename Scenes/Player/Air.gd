extends PlayerState

@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer")
@onready var snd_fall : AudioStreamPlayer = get_node("../../snd_fall")

# AIR

func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = - player.jump_impulse
		get_node("../../snd_walk").stop()
		get_node("../../snd_jump").play()
		anim_player.play("jump")
			
	player.Foot_R.rotation = deg_to_rad(85)
	player.Foot_L.rotation = deg_to_rad(65)
	print("Player: Air")

func physics_update(delta: float) -> void:
	
	if player.is_on_floor():
		if gv.Player_is_paused == true:
			state_machine.transition_to("Idle")
			return
	
	if Input.is_action_pressed("ui_right"):
		player.velocity.x = player.speed
	
	if Input.is_action_pressed("ui_left"):
		player.velocity.x = -player.speed	
	
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if player.SlopeRayCast.is_colliding():
		player.Foot_R.rotation = deg_to_rad(0)
		player.Foot_L.rotation = deg_to_rad(0)			
	else:
		player.Foot_R.rotation = deg_to_rad(85)
		player.Foot_L.rotation = deg_to_rad(65)	

	if player.is_on_floor() == true:
		anim_player.play("touch_down")
		player.velocity = Vector2.ZERO
		snd_fall.play()
					
func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "touch_down":
		state_machine.transition_to("Idle")
	
