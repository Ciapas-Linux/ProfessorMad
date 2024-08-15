extends PlayerState

#.#############>
#. WALK 🌟🌟🌟#>
#.#############>


var ray_normal:Vector2
var offset: float

@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer")

func enter(_msg := {}) -> void:
	if get_node("../../snd_walk").playing != true:
			get_node("../../snd_walk").play()

	anim_player.stop()
	
	print("Player: previous state " + player.Player_fsm.previous_state)
	print("Player state: " + self.name)
	
# Exit state:	
func exit() -> void:
	print("Player exit state: " + self.name)
	
func physics_update(delta: float) -> void:
		
	if player.Player_is_paused == true:
		state_machine.transition_to("Idle")
		return	
		
	player.velocity.x = player.speed * player.Player_direction.x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	# Detect slopes:
	if player.is_on_floor() and player.SlopeRayCast.is_colliding():
		offset = deg_to_rad(90)
		ray_normal =  player.SlopeRayCast.get_collision_normal()
		player.Player_tilt = (int)(rad_to_deg(ray_normal.angle() + offset ) * -1)
		
		# No slope tilt < 10 as no slope:
		if player.Player_tilt < 10 and player.Player_tilt > -10:
			if anim_player.get_current_animation() != "walkx":
				anim_player.play("walkx")		
				anim_player.seek(0.3,true)
			get_node("../../CollisionShape2D").shape.height = 700
			player.Foot_R.rotation = ray_normal.angle() + deg_to_rad(90)
			player.Foot_L.rotation = ray_normal.angle() + deg_to_rad(90)
			player.Player_up_down = 0	# flat = 0	
		
		# Slope:
		elif player.Player_tilt > 10 or player.Player_tilt < -10:
			if anim_player.get_current_animation() != "walkx":
				anim_player.play("walkx")
				anim_player.seek(0.3,true)
			#get_node("../../CollisionShape2D").shape.height = 600	
							
			if player.Player_tilt < 0:
				if player.Player_direction == Vector2.RIGHT: # going DOWN:
					player.Foot_R.rotation = ray_normal.angle() + deg_to_rad(90)
					player.Foot_L.rotation = ray_normal.angle() + deg_to_rad(90)
					get_node("../../CollisionShape2D").shape.height = 720
					player.Player_up_down = 2	# down = 2
				if player.Player_direction == Vector2.LEFT: # going UP:
					player.Foot_R.rotation = -(ray_normal.angle() + deg_to_rad(90))
					player.Foot_L.rotation = -(ray_normal.angle() + deg_to_rad(90))
					get_node("../../CollisionShape2D").shape.height = 600
					player.Player_up_down = 1	# up = 1

			if player.Player_tilt > 0:
				if player.Player_direction == Vector2.RIGHT: # going UP:
					player.Foot_R.rotation = ray_normal.angle() + deg_to_rad(90)
					player.Foot_L.rotation = ray_normal.angle() + deg_to_rad(90)
					get_node("../../CollisionShape2D").shape.height = 600
					player.Player_up_down = 1	# up = 1
				if player.Player_direction == Vector2.LEFT: # going DOWN:
					player.Foot_R.rotation = -(ray_normal.angle() + deg_to_rad(90))
					player.Foot_L.rotation = -(ray_normal.angle() + deg_to_rad(90))
					get_node("../../CollisionShape2D").shape.height = 700
					player.Player_up_down = 2	# down = 2


	if Input.is_action_just_pressed("ui_up"):
		state_machine.transition_to("Air", {do_jump = true})
	
	if Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		state_machine.transition_to("Idle")













