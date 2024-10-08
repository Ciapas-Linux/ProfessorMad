extends PlayerState


@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer")

var wave_speed: float = 300


func enter(msg := {}) -> void:

	if msg.has("back_area"):
		anim_player.play("shockwave_right")
		player.velocity.x = player.speed
		
	if msg.has("front_area"):
		anim_player.play("shockwave_left")
		player.velocity.x = -player.speed			

	player.Player_weapon.visible = false
		
	get_node("../../snd_hit2").play()
	get_node("../../snd_body_fall").play()
	
	print("Player: previous state " + player.Player_fsm.previous_state)
	print("Player state: " + self.name)

# Exit state:	
func exit() -> void:
	print("Player exit state: " + self.name)

func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta	
	player.move_and_slide()


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if player.Player_fsm.state.name == "Shockvawe":
		if anim_name == "shockwave_back" or anim_name == "shockwave_right":
			player.Player_weapon.visible = true
			#player.fade_in()
			player.velocity.x = 0
			await get_tree().create_timer(1.6).timeout
			state_machine.transition_to("Idle")

	




	# if gv.Player_direction == Vector2.LEFT: