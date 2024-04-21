extends PlayerState


@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer")

var stop_move:bool = false
var wave_speed: float = 300

func enter(msg := {}) -> void:

	if msg.has("back_area"):
		anim_player.play("shockwave_right")
		
	if msg.has("front_area"):
		anim_player.play("shockwave_left")			

	gv.Hero_weapon.visible = false
		
	get_node("../../snd_hit2").play()
	get_node("../../snd_body_fall").play()
	
	print("Player: enter state machine shockwave!")

func physics_update(delta: float) -> void:
	if stop_move == false:
		player.velocity.y += player.gravity * delta
		if gv.Hero_direction == Vector2.LEFT:
			player.velocity.x = -player.speed
		if gv.Hero_direction == Vector2.RIGHT:
			player.velocity.x = player.speed	
	player.move_and_slide()


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "shockwave_back" or anim_name == "shockwave_right":
		gv.Hero_weapon.visible = true
		#player.fade_in()
		stop_move = true
		player.velocity.x = 0
		await get_tree().create_timer(1.6).timeout
		state_machine.transition_to("Idle")

	