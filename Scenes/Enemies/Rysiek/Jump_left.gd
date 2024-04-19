extends RysiekState

# #####################
# # JUMP LEFT.SCRIPT   #
# #####################

var stop:bool = false

func enter(_msg := {}) -> void:
	rysiek.velocity.y = - rysiek.jump_impulse
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("Jump")
	if get_node("../../snd_jump").playing != true:
		get_node("../../snd_jump").play()
	print("rysiek fsm: JUMP LEFT")
	
@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:

	# GAME PAUSE:
	""" if gv.Game_pause == true:
		rysiek.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """
				
	rysiek.velocity.x = - rysiek.speed + 100
	rysiek.velocity.y += rysiek.gravity * delta
	
	rysiek.move_and_slide()
		
	if rysiek.is_on_floor():
		if get_node("../../snd_fall").playing != true:
			get_node("../../snd_fall").play()
		get_node("../../AnimationPlayer").stop()
		get_node("../../AnimationPlayer").play("idle")	
		print("rysiek: Jump_left to floor")
		# await get_tree().create_timer(0.1).timeout
		rysiek.previous_state = gv.enemy_fsm.estate.name
		rstate_machine.transition_to("idle")
	
	
