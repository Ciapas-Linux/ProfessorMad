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
	
	if gv.Player_current_weapon == 2:
		anim_player.play("target_up_rpg")
	else:
		anim_player.play("target_up")
	
	if gv.Player_weapon.is_connected("fire", _on_gun_2_fire) == false:
		gv.Player_weapon.connect("fire", _on_gun_2_fire)
		
	print("Player: Target up")	


func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	if gv.Player_is_paused == true:
		state_machine.transition_to("Idle")
		return

	if Input.is_action_just_pressed("Reload"):
		gv.Player_weapon.reload()
		print("Player: reload weapon")			
				
	if Input.is_action_pressed("ui_right"):
		gv.Player_direction = Vector2.RIGHT
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

#	
	if walk == true:
		anim_player.play("target_up_walk")
		if get_node("../../snd_walk").playing != true:
			get_node("../../snd_walk").play()			
		
	
	if Input.is_action_just_pressed("ui_up"):
		state_machine.transition_to("Idle")

	if Input.is_action_just_pressed("ui_down"):
		state_machine.transition_to("Idle")	

	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if player.is_on_floor() and player.SlopeRayCast.is_colliding():
		ray_normal =  player.SlopeRayCast.get_collision_normal()
		player.Foot_R.rotation = ray_normal.angle() + deg_to_rad(90)
		player.Foot_L.rotation = ray_normal.angle() + deg_to_rad(90)
		gv.Player_tilt = (int)(rad_to_deg(ray_normal.angle() + deg_to_rad(90) ) * -1)



func _on_gun_2_fire() -> void:
	if gv.fsm.state.name == "target_up":
		if player.turn == true:
			player.position.x -= 3
		else:	
			player.position.x += 3












# func _on_animation_player_2_animation_finished(_anim_name:StringName) -> void:
# 	if gv.Player_current_weapon == 0:
# 		await get_tree().create_timer(1.0).timeout
# 		#state_machine.transition_to("Idle")










""" func _one_shot_timer_example():
	print("timer start")
	await get_tree().create_timer(1.0).timeout
	print("timer end") """

