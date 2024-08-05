extends RysiekState

# #####################
# # JUMP RIGHT.SCRIPT #
# #####################

var stop:bool = false

func enter(_msg := {}) -> void:
	rysiek.velocity.y = - rysiek.jump_impulse
	rysiek.anim_player.stop()
	rysiek.anim_player.play("Jump")
	if get_node("../../snd_jump").playing != true:
		get_node("../../snd_jump").play()
	print("Rysiek state: Jump_right")
	
# Exit state:	
func exit() -> void:
	#gv.rysiek_fsm.previous_state = "Jump_right"
	print("Rysiek state: Exit Jump_right state")

func physics_update(delta: float) -> void:

	# GAME PAUSE:
	""" if gv.Game_pause == true:
		rysiek.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """
				
	rysiek.velocity.x = rysiek.speed + 100
	rysiek.velocity.y += rysiek.gravity * delta
	
	#if stop == false:
	rysiek.move_and_slide()
		
	if rysiek.is_on_floor():
	#if stop == false:
		if get_node("../../snd_fall").playing != true:
			get_node("../../snd_fall").play()
		rysiek.anim_player.stop()
		rysiek.anim_player.play("idle")	
		# await get_tree().create_timer(0.5).timeout
		rstate_machine.transition_to("idle")
	
	
