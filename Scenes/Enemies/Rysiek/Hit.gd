extends RysiekState

# ####################
# # HIT       SCRIPT #
# ####################

@onready var snd_player:AudioStreamPlayer2D = get_node("../../hurt_player")


func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("hitme")
	print("enemy fsm: THEY HIT ME")
	#if get_node("../../Snd_hit1").playing != true:
			#get_node("../../Snd_hit1").play()
	
	snd_player.stream = rysiek.hurt_sounds[randi() % len(rysiek.hurt_sounds)]
	if snd_player.playing != true:
		snd_player.play()		
	

@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:
	
	# GAME PAUSE:
	""" if gv.Game_pause == true:
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hitme":
		#enemy.previous_state = gv.fsm.state.name
		rstate_machine.transition_to(rysiek.previous_state)
		#print(enemy.previous_state)


func _on_enemy_somebody_hitme() -> void:
	
	pass 
