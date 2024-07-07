extends PlayerState

var walk:bool = false
var walk_speed:float
 
@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer")

var ray_normal:Vector2
var floor_normal:Vector2

func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	walk_speed = player.speed/2
	
	if get_node("../../snd_sit").playing != true:
			get_node("../../snd_sit").play()	
	
	get_node("../../snd_walk").stop()
	get_node("../../snd_fall").stop()
	
	#anim_player.stop()
	anim_player.set_blend_time("idle", "target_down",0.6)
	anim_player.play("target_down")
	
	if gv.Player.Player_weapon.is_connected("fire", _on_gun_2_fire) == false:
		gv.Player.Player_weapon.connect("fire", _on_gun_2_fire)
		
	print("Player: Target down")	

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
		
	if gv.Player.Player_is_paused == true:
		state_machine.transition_to("Idle")
		return		

	if Input.is_action_pressed("ui_right"):
		player.velocity.x = walk_speed
		walk = true
		
	# walk backward
	if Input.is_action_pressed("ui_left"):
		player.velocity.x = -walk_speed
		walk = true	
	
	if Input.is_action_just_released("ui_right"):		
		walk = false
		player.velocity.x = 0
		anim_player.stop()
		get_node("../../snd_walk").stop()	
				
	if Input.is_action_just_released("ui_left"):		
		walk = false
		player.velocity.x = 0
		anim_player.stop()
		get_node("../../snd_walk").stop()	
		
	if walk == true:
		anim_player.play("target_down_walk")
		if get_node("../../snd_walk").playing != true:
			get_node("../../snd_walk").play()
		
	
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if player.is_on_floor() and player.SlopeRayCast.is_colliding():
		ray_normal =  player.SlopeRayCast.get_collision_normal()
		gv.Player.Player_tilt = (int)(rad_to_deg(ray_normal.angle() + deg_to_rad(90) ) * -1)
		
		# No slope:
		if gv.Player.Player_tilt < 10 and gv.Player.Player_tilt > -10:
			player.Foot_R.rotation = ray_normal.angle() + deg_to_rad(90)
			player.Foot_L.rotation = ray_normal.angle() + deg_to_rad(90)
		# Slope:
		elif gv.Player.Player_tilt > 10 or gv.Player.Player_tilt < -10:
			if gv.Player.Player_tilt < 0:
				if gv.Player.Player_direction == Vector2.RIGHT: # going DOWN:
					player.Foot_R.rotation = ray_normal.angle() + deg_to_rad(90)
					player.Foot_L.rotation = ray_normal.angle() + deg_to_rad(90)
				if gv.Player.Player_direction == Vector2.LEFT: # going UP:
					player.Foot_R.rotation = -(ray_normal.angle() + deg_to_rad(90))
					player.Foot_L.rotation = -(ray_normal.angle() + deg_to_rad(90))

			if gv.Player_tilt > 0:
				if gv.Player.Player_direction == Vector2.RIGHT: # going UP:
					player.Foot_R.rotation = ray_normal.angle() + deg_to_rad(90)
					player.Foot_L.rotation = ray_normal.angle() + deg_to_rad(90)
				if gv.Player.Player_direction == Vector2.LEFT: # going DOWN:
					player.Foot_R.rotation = -(ray_normal.angle() + deg_to_rad(90))
					player.Foot_L.rotation = -(ray_normal.angle() + deg_to_rad(90))

	
	if Input.is_action_just_pressed("ui_up"):
		state_machine.transition_to("Idle")
	
func _on_gun_2_fire() -> void:
	if gv.fsm.state.name == "target_down":
		if player.turn == true:
			player.position.x -= 3
		else:	
			player.position.x += 3
