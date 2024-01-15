
# ##########################>
# # Rocket 4 launcher misille .SCRIPT #
# ##########################>


extends Area2D

@export var max_speed := 800.0
@export var drag_factor := 0.15   #ORG: 0.15
var _current_velocity:Vector2 = Vector2.ZERO
var target:Node2D = null
var hit:bool = false
var direction:Vector2 = Vector2.ZERO

func _enter_tree() -> void:
	target = gv.mouse_enter_node

func set_drag_factor(new_value: float) -> void:
	drag_factor = clamp(new_value, 0.01, 0.5)

func _ready():
	$sprite_flame.visible = true
	$sprite_flame.play()
	$hit_sprite.visible = false
	$snd_fire1.play()
	$snd_fire2.play()
	$war_head.play("rotate")
	$Timer.start()
	_current_velocity = max_speed * 5 * Vector2.RIGHT.rotated(rotation)
	rotation += randf_range(-0.19, 0.19)
	set_drag_factor(0.15)
	print("Player release rocket_4 head: " + self.name)


func _physics_process(delta):
		if hit == true:
			return

		direction = Vector2.RIGHT.rotated(rotation).normalized()
	
		if target:
			direction = global_position.direction_to(target.global_position)
			var desired_velocity := direction * max_speed
			#var previous_velocity = _current_velocity
			var change = (desired_velocity - _current_velocity) * drag_factor
			_current_velocity += change
			position += _current_velocity * delta
			look_at(global_position + _current_velocity)
		

func _on_area_entered(area):
	print("Rocket_4 hit Area2D: " + area.name)
	print("Rocket_4 target node name: " + target.name)
	if target.name != area.name:
		return
	if area.has_method("rpg_hit"):
		area.rpg_hit()
	$snd_continue.stop()
	$war_head.visible = false
	$snd_fire2.stop()
	$snd_fire1.play()		
	$war_head.visible = false
	$sprite_flame.visible = false
	$hit_sprite.visible = true
	$hit_sprite.play("explode")
	$CollisionShape2D.set_deferred("disabled", true)
	gv.set_cursor_green()
	hit = true
	
				
func _on_body_entered(body):
	print("Rocket_4 hit Body: " + body.name)
	print("Rocket_4 target node name: " + target.name)
	if target.name != body.name:
		return
	if body.has_method("rpg_hit"):
		body.rpg_hit()
	$snd_continue.stop()
	$war_head.visible = false
	$snd_fire2.stop()
	$snd_fire1.play()	
	$war_head.visible = false
	$sprite_flame.visible = false
	$hit_sprite.visible = true
	$hit_sprite.play("explode")
	$CollisionShape2D.set_deferred("disabled", true)
	gv.set_cursor_green()
	hit = true
	
# if no hit destroy node after some time:	
func _on_timer_timeout() -> void:
	queue_free()

func _on_hit_sprite_animation_finished() -> void:
	queue_free()











#############
# SCRAP CODE:
####################################################
####################################################

#func _input(event):
#    get_viewport().set_input_as_handled()


#var destination_point:Vector2
#var actual_distance:float = 0.0

#@export var steer_force = 50.0

#@export var speed:float = 1500 
#@export var steering_force = 50.0
#var velocity:Vector2 = Vector2.ZERO
#var acceleration:Vector2 = Vector2.ZERO


# steering_force = randf_range(50.0,100.0)


# # steer the missile towards the target:
# func steer():
# 	# Define as velocity to steer
# 	var steering = Vector2()
# 	# Define ideal velocity (direction x speed towards player character from current position)
# 	var ideal_velocity = (target.position - position).normalized() * speed
# 	# speed to steer = direction vector obtained by ideal_velocity - current_velocity x force to steer
# 	steering = (ideal_velocity - velocity).normalized() * steering_force
# 	# output velocity to steer
# 	return steering



# if target != null:
	# 	actual_distance = self.global_position.distance_to(target.global_position)
	# 	#steering_force /=  actual_distance
	# 	velocity = transform.x * speed
	# 	# Add: add velocity to steer to acceleration
	# 	acceleration += steer()
	# 	# Add: add the velocity plus the acceleration x delta value to the velocity
	# 	velocity += acceleration * delta
	# 	# Add: limit the length of the velocity vector so that it does not exceed the speed
	# 	velocity = velocity.limit_length(speed)
	# 	position += velocity * delta
	# 	rotation = velocity.angle()