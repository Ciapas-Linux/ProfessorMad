extends PlayerState

@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer")
@onready var snd_fall : AudioStreamPlayer = get_node("../../snd_fall")

# AIR from RUN

#var from_run:bool = false

var ray_normal:Vector2
var floor_normal:Vector2
var touch_ground:bool = false 

func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = - player.jump_impulse_run
		get_node("../../snd_walk").stop()
		get_node("../../snd_jump").play()
		anim_player.play("jump")
	
	player.Foot_R.rotation = deg_to_rad(85)
	player.Foot_L.rotation = deg_to_rad(65)
	print("Player: previous state " + player.Player_fsm.previous_state)
	print("Player state: " + self.name)

	# if gv.fsm.previous_state == "run_right":
	# 	from_run = true
	# 	print("Player: Jump from run ")

# Exit state:	
func exit() -> void:
	touch_ground = false 
	print("Player exit state: " + self.name)

func physics_update(delta: float) -> void:
	
	# if player.is_on_floor():
	# 	if player.Player_is_paused == true:
	# 		state_machine.transition_to("Idle")
	# 		return	
	
	if Input.is_action_pressed("ui_right"):
		player.velocity.x = player.speed_run
	
	if Input.is_action_pressed("ui_left"):
		player.velocity.x = -player.speed_run	
	
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if player.SlopeRayCast.is_colliding():
		ray_normal =  player.SlopeRayCast.get_collision_normal()
		player.Foot_R.rotation = ray_normal.angle() + deg_to_rad(90)
		player.Foot_L.rotation = ray_normal.angle() + deg_to_rad(90)	
	else:
		player.Foot_R.rotation = deg_to_rad(85)
		player.Foot_L.rotation = deg_to_rad(65)	
		
	if player.is_on_floor() == true:
		if touch_ground == false:
			touch_ground = true
			anim_player.play("touch_down")
			player.velocity = Vector2.ZERO
			#state_machine.transition_to("Idle")
			snd_fall.play() 	
				
func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if player.Player_fsm.state.name == "Air_run":
		if anim_name == "touch_down":
			state_machine.transition_to("Idle")
	
