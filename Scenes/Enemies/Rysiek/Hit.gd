extends RysiekState

# ####################
# # HIT       SCRIPT #
# ####################

@onready var snd_player:AudioStreamPlayer2D = get_node("../../hurt_player")

func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	get_node("../../AnimationPlayer").play("hitme")
			
	snd_player.stream = rysiek.hurt_sounds[randi() % len(rysiek.hurt_sounds)]
	snd_player.volume_db = 10
	snd_player.play()	
		
	print("Rysiek enter state: Hit")
	print("Rysiek previous state: " + gv.rysiek_fsm.previous_state)

# Exit state:	
func exit() -> void:
	gv.rysiek_fsm.previous_state = "Hit"
	print("Rysiek state: Exit Hit state")

@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:
	
	# GAME PAUSE:
	""" if gv.Game_pause == true:
		enemy.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hitme":
		gv.rysiek_fsm.transition_to("idle")
		
		
