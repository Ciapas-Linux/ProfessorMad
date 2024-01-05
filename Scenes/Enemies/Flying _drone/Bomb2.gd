extends Area2D

var speed:int = 100

var drone:CharacterBody2D
var bomb_hit_target:bool = false
var drone_on_position:bool = false

signal early_hit

func _ready():
	drone = get_parent().get_node("Flying_drone")
	position.x = drone.global_position.x
	position.y = drone.global_position.y + 50
	$Explosion.stop()
	$Explosion.visible = false
	$BombSprite.visible = true
	$AnimationPlayer.play("rotate")
	$BombSprite.play("rotate")
	bomb_hit_target = false
	speed = randi_range(400,1100)
	drone.connect('on_hit_position', _on_hit_position)
	#print(get_parent().name)
	
	
func _physics_process(delta):
	if bomb_hit_target == false:
		if drone_on_position == false:
			position.x = drone.global_position.x
			position.y = drone.global_position.y + 50
		else:
			position += transform.y * speed * delta
							
	
func explode():
	$snd_fall.stop()
	bomb_hit_target = true
	$BombSprite.visible = false
	$Explosion.visible = true
	$AnimationPlayer.stop(true)
	$Explosion.play("explode")
	$snd_explode.play()
	
	#ShakeScreen.shake(30,0.5)
	gv.Cam1.ScreenShake(30,0.5)
	
func rpg_hit():	
	$snd_fall.stop()
	bomb_hit_target = true
	$BombSprite.visible = false
	$Explosion.visible = true
	$AnimationPlayer.stop(true)
	$Explosion.play("explode")
	$snd_explode.play()
	#ShakeScreen.shake(30,0.5)
	gv.Cam1.ScreenShake(30,0.5)


# bomb is on hit target position	
func _on_hit_position():
	if bomb_hit_target == false:
		drone_on_position = true
		$AnimationPlayer.stop(true)
		$AnimationPlayer.play("fall_off")
		$snd_fall.play()
		print("Bomb is on target position")
	

# if bomb hit Area2D
func _on_area_entered(area):
	print("Bomb hit Area2D: " + area.name)
	$CollisionShape2D.set_deferred("disabled", true)
	if area.name.left(6) == "Bullet":
		emit_signal("early_hit")
	if area.has_method("bomb_explode"):
		area.bomb_explode()	
	
	explode()	


# if bomb hit Body2D
func _on_body_entered(body):
	print("Bomb hit Body: " + body.name)
	if (body.name == "Enemy"):
		return
	bomb_hit_target = true
	speed = randi_range(500,600)
	$CollisionShape2D.set_deferred("disabled", true)
	#await get_tree().create_timer(0.5).timeout  
	explode()
	if body.has_method("bomb_explode"):
		body.bomb_explode()	


# If bullet hit bomb
func _on_bullet_hits_area_entered(area: Area2D) -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	if area.name.left(6) == "Bullet":
		#$snd_fall.stop()	
		print("Bomb:" + area.name + " hit me and finish me" )
		explode()
		if drone_on_position == false:
			emit_signal("early_hit")
			
	
	
func _on_explosion_animation_finished() -> void:
	$snd_fall.stop()
	queue_free()










#	position += transform.y * speed * delta
	#position.y += speed
	
#	if bomb_hit_target == false:
#		if gv.Drone1_on_position == false:
#			position.x = gv.Drone1_global_position.x
#			position.y = gv.Drone1_global_position.y
#		else:
#			gravity = randf_range(50,80)
#			velocity.y += gravity * delta
#			collision = move_and_collide(velocity * delta)
#			if collision:
#				print("Bomb: I hit ", collision.get_collider().name)
#				collider_name = collision.get_collider().name
#				match collider_name:
#					"Player":
#						#await get_tree().create_timer(0.5).timeout
#						explode()
#					"GruntBody2D":
#						explode()
						
		



