extends PlayerState

@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer")
@onready var snd_fall : AudioStreamPlayer = get_node("../../snd_fall")

# AIR:jumping

var delay_timer : Timer
var ray_normal:Vector2
var floor_normal:Vector2
var start_check_floor : bool = false

func enter(msg := {}) -> void:
	
	# Do Jump:
	if msg.has("do_jump"):
		#player.velocity.y = - player.jump_impulse
		get_node("../../snd_walk").stop()
		get_node("../../snd_jump").play()
		#anim_player.set_blend_time("idle", "jump_start",0.6)
		anim_player.play("jump_start")

	# Falling down when start from Air:
	if msg.is_empty():		
		player.Foot_R.rotation = deg_to_rad(85)
		player.Foot_L.rotation = deg_to_rad(65)
		anim_player.play("jump")
	
	start_check_floor = false

	delay_timer = Timer.new()
	add_child(delay_timer)
	delay_timer.wait_time = 0.3
	delay_timer.one_shot = true
	delay_timer.connect("timeout", _on_timer_timeout)
	delay_timer.start()
	
	print("Player: Air")

func _on_timer_timeout():
	start_check_floor = true	

func physics_update(delta: float) -> void:
	
	if player.is_on_floor():
		if gv.Player_is_paused == true:
			state_machine.transition_to("Idle")
			return
	
	if Input.is_action_pressed("ui_right"):
		player.velocity.x = player.speed
	
	if Input.is_action_pressed("ui_left"):
		player.velocity.x = -player.speed	
	
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if player.SlopeRayCast.is_colliding():
		ray_normal =  player.SlopeRayCast.get_collision_normal()
		player.Foot_R.rotation = ray_normal.angle() + deg_to_rad(90)
		player.Foot_L.rotation = ray_normal.angle() + deg_to_rad(90)
	else:
		player.Foot_R.rotation = deg_to_rad(85)
		player.Foot_L.rotation = deg_to_rad(65)	

	if start_check_floor == true:
		if player.is_on_floor() == true:
			anim_player.play("touch_down")
			player.velocity = Vector2.ZERO
			snd_fall.play()
					
func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "touch_down":
		state_machine.transition_to("Idle")
	if anim_name == "jump_start":
		player.velocity.y = - player.jump_impulse
		anim_player.play("jump")
		
	
