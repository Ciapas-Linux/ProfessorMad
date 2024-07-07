extends PlayerState



@onready var anim_player : AnimationPlayer = get_node("../../AnimationPlayer")
@onready var snd_fall : AudioStreamPlayer = get_node("../../snd_fall")

#@onready var footR_CollisionShape2D : CollisionShape2D = get_node("../../footR_CollisionShape2D")
#@onready var footL_CollisionShape2D : CollisionShape2D = get_node("../../footL_CollisionShape2D")



const START_MOVE_UP: int = 0
const MOVE_UP: int = 1
const FALL_DOWN: int = 2

var delay_timer : Timer
var current_state : int = FALL_DOWN
var start_check_floor : bool = false

func enter(msg := {}) -> void:

	delay_timer = Timer.new()
	add_child(delay_timer)
	delay_timer.wait_time = 0.3
	delay_timer.one_shot = true
	delay_timer.connect("timeout", _on_timer_timeout)

	if msg.has("do_jump"):
		#anim_player.stop()
		get_node("../../snd_walk").stop()
		current_state = START_MOVE_UP
		anim_player.play("jump_start")
		print("Player: Start jump up")
		#player.velocity.y = -player.jump_impulse
		#footR_CollisionShape2D.set_deferred("disabled", true)
	# else:
	# 	if not player.is_on_floor():
	# 		current_state = FALL_DOWN

func _on_timer_timeout():
	#footR_CollisionShape2D.set_deferred("disabled", false)
	#footL_CollisionShape2D.set_deferred("disabled", false)
	start_check_floor = true		

func physics_update(delta: float) -> void:
	match current_state:
		START_MOVE_UP:
			#print("Player: Air --> START_MOVE_UP")
			pass
		
		MOVE_UP:
			if Input.is_action_pressed("ui_right"):
				player.velocity.x = player.speed
		
			if Input.is_action_pressed("ui_left"):
				player.velocity.x = -player.speed	
			
			
			player.velocity.y += player.gravity * delta
			player.move_and_slide()

			#print("Player: Air --> MOVE_UP")
			
			if start_check_floor == true:
				check_touch_down()
		
		FALL_DOWN:
			if Input.is_action_pressed("ui_right"):
				player.velocity.x = player.speed
		
			if Input.is_action_pressed("ui_left"):
				player.velocity.x = -player.speed	
			
			player.velocity.y += player.gravity * delta
			player.move_and_slide()
			check_touch_down()
			#print("Player: Air --> FALL_DOWN")
			
				
func check_touch_down() -> void:
	if player.is_on_floor() == true:
		anim_player.play("touch_down")
		state_machine.transition_to("Idle")
		snd_fall.play()

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "jump_start":
		get_node("../../snd_jump").play()
		anim_player.play("jump")
		current_state = MOVE_UP
		player.velocity.y = -player.jump_impulse
		player.Foot_R.rotation = deg_to_rad(85)
		player.Foot_L.rotation = deg_to_rad(85)
		#footR_CollisionShape2D.set_deferred("disabled", true)
		#footL_CollisionShape2D.set_deferred("disabled", true)
		delay_timer.start()
		print("Player: Jump")