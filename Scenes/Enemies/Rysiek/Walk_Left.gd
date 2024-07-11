extends RysiekState

# #####################
# # WALK LEFT.SCRIPT  #
# #####################

@onready var But_L_spr:Sprite2D = get_node("../../CanvasGroup/Noga_L/But_L")
@onready var But_P_spr:Sprite2D = get_node("../../CanvasGroup/Noga_P/But_P")

var player_distance:float

func enter(_msg := {}) -> void:
	get_node("../../AnimationPlayer").stop()
	rysiek.scale.x = rysiek.scale.y * 1
	rysiek.rysiek_direction = Vector2.LEFT
	get_node("../../AnimationPlayer").play("walk")
	print("Rysiek state: Walk_left")
	

# Exit state:	
func exit() -> void:
	gv.rysiek_fsm.previous_state = "Walk_left"


#@warning_ignore("unused_parameter")	
func physics_update(delta: float) -> void:
	rysiek.velocity.x = -rysiek.speed
	rysiek.velocity.y += rysiek.gravity * delta
	player_distance = rysiek.global_position.distance_to(gv.Player.global_position)

	# GAME PAUSE:
	""" if gv.Game_pause == true:
		rysiek.previous_state = gv.enemy_fsm.estate.name
		estate_machine.transition_to("Pause") """
	
	if get_node("../../snd_walk").playing != true:
			get_node("../../snd_walk").play()
			
	if player_distance < rysiek.contact_distance + 500:
		# if gv.Hero_pos_x + rysiek.change_direction_distance < rysiek.position.x:
		# 	rysiek.scale.x = rysiek.scale.y * 1
		# 	rysiek.direction = "L"
		# if gv.Hero_pos_x - rysiek.change_direction_distance > rysiek.position.x:
		# 	rysiek.scale.x = rysiek.scale.y * -1
		# 	rysiek.direction = "R"

		get_node("../../AnimationPlayer").stop()
		#rysiek.previous_state = gv.enemy_fsm.estate.name
		rstate_machine.transition_to("idle")		

#	if rysiek.see_Player == true:
#		get_node("../../AnimationPlayer").stop()
#		rysiek.previous_state = gv.enemy_fsm.estate.name
#		estate_machine.transition_to("idle")
		
#	if rysiek.position.distance_to(gv.Hero_global_position) > 500:
#		rysiek.previous_state = gv.enemy_fsm.estate.name
#		get_node("../../AnimationPlayer").stop()
#		estate_machine.transition_to("idle")
	
			
	rysiek.move_and_slide()

	But_L_spr.rotation = rysiek.get_floor_angle()
	But_P_spr.rotation = rysiek.get_floor_angle()

	if rysiek.is_on_wall():	
		#rysiek.previous_state = gv.enemy_fsm.estate.name
		get_node("../../AnimationPlayer").stop()
		print("enemy2: stop on wall going left")
		rstate_machine.transition_to("Jump_left")

	if rysiek.is_on_floor() == false:
		#rysiek.previous_state = gv.enemy_fsm.estate.name
		rstate_machine.transition_to("Air")		