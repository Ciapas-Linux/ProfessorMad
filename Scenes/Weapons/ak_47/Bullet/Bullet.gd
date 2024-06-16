extends Area2D

@export var speed:float = 0.0003
var distance:float = 0.0
var destination_point:Vector2
var start_point:Vector2


func _enter_tree() -> void:
	destination_point = get_global_mouse_position()
	# XXXXXX:
	# Signal from every bullet when enter to scene tree for bullet holes nodes:
	gv.emit_signal("player_bullet_ready")

func _ready():
	$BulletCrash.visible = false
	$CollisionShape2D.disabled = true
	distance = global_position.distance_to(destination_point)
	start_point = global_position
	var tween = create_tween()
	tween.connect("finished", on_tween_finished)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", destination_point, distance*speed)
	print("Player bullet: " + self.name)
	
func _physics_process(_delta):
	if global_position.distance_to(start_point) > 3500:
		print("Player bullet out of range: "  + self.name)
		queue_free()

func on_tween_finished():
	$CollisionShape2D.disabled = false
	$BulletSprite.visible = false
	$BulletCrash.visible = true 
	$BulletCrash.play("hit_anim")
	$snd_bullet_hit.play()

	
func _on_area_entered(area):
	print("Player bullet hit Area2D: " + area.name)
	$snd_bullet_hit.play()
	if area.has_method("hit"):
		area.hit()
	$BulletSprite.visible = false
	$BulletCrash.visible = true 
	$BulletCrash.play("hit_anim")
	
func _on_body_entered(body):
	$snd_bullet_hit.play()
	print("Player bullet hit Body: " + body.name)
	if body.has_method("hit"):
		body.hit()	
	$BulletSprite.visible = false
	$BulletCrash.visible = true 
	$BulletCrash.play("hit_anim")
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_bullet_crash_animation_finished() -> void:
	queue_free()
	













#var area_hit:bool = false
#var body_hit:bool = false






# func _physics_process(_delta: float) -> void:
#	 pass


# func _on_timer_timeout() -> void:
# 	$CollisionShape2D.disabled = true
# 	monitorable = false
# 	monitoring = false
# 	print("@@@@@@@@@@@@@@@@: timeout")





# var local_cursor_position:Vector2
#var tt: float = 0.0
#var destination:bool = false
#var start_point:Vector2
#var timer :Timer






#print("DDDD---Distance: " + str(distance))

# $BulletCrash.stop()


# global_cursor_position = get_tree().get_root().get_node("/root/Stage1/maluch").get_global_mouse_position()
	
	
	# destination_point = get_global_mouse_position()
	# gv.emit_signal("player_bullet_ready")
	
	# local_cursor_position = get_local_mouse_position()
	# local_cursor_position = get_tree().get_root().get_node("/root/Stage1/maluch").get_local_mouse_position()
	# $CollisionShape2D.set_deferred("disabled", true)


#timer = Timer.new()
	#timer.wait_time = 0.05
	#timer.one_shot = true
	#timer.connect("timeout", _on_timer_timeout)
	#add_child(timer)
	#start_point = global_position




#if area_hit == false and body_hit == false and destination == false:
		# tt += delta * 1.4			
		
		# position += transform.x * speed * delta
		# print("XXXXXXXXX: " + str(transform.x * speed * delta))
		
		
		# print("DELTA: " + str(delta))
		# position += Vector2(10.0,10)
		# position = start_point.lerp(destination_point, tt)
		# print("XXXXXXXX: " + str(global_position.distance_to(destination_point)))
		# print("XXXXXXXX: " + str(global_position.distance_squared_to(destination_point)))
		
		#distance = global_position.distance_to(destination_point)
		#print("XXXXXXXXX: " + str(distance))
		
		# if distance < 35:   # 35	
		# 	print("bullet dest. distance: " + str(distance))
		# 	# $CollisionShape2D.set_deferred("disabled", false)
		# 	$CollisionShape2D.disabled = false
		# 	destination =  true	
		# 	$BulletSprite.visible = false
		# 	$BulletCrash.visible = true 
		# 	$BulletCrash.play("hit_anim")
		# 	$snd_bullet_hit.play()
			



#func _process(_delta: float) -> void:
	#distance = global_position.distance_to(destination_point)
	#print("XXXXXXXXX: " + str(distance))
	#pass







#timer.start() 
			# monitorable = false
			# monitoring = false

# print("XXXXXXXX: " + str(global_position.distance_to(destination_point)))
# print("XXXXXXXX: " + str(global_position.distance_squared_to(destination_point)))
		
		

# distance = abs(global_position.distance_to(destination_point))


#print(cursor_position)



# $CollisionShape2D.disabled = true
	# $CollisionShape2D.set_deferred("disabled", true)  



#if area_hit == false and body_hit == false:	
		#position += transform.x * speed * delta
	
	#if area_hit == true:
		#pass
	
	#if body_hit == true:
		#pass

	
	#if global_position.x > cursor_position.x and global_position.y > cursor_position.y:
		#queue_free()	
		#hit_target = true

	#velocity = input_dir.normalized() * speed
	#var collision = move_and_collide(speed * delta)	




# if has_overlapping_areas() == true:
			# 	print("bullet overlap area !!!!")

			# if has_overlapping_bodies() == true:
			# 	print("bullet overlap body !!!!")	

			# if hit_target == false:
			# 	if area_hit == true:
			# 		hit_target = true
			# 		if area_node.has_method("hit"):
			# 			area_node.hit()
			# 		$BulletSprite.visible = false
			# 		$BulletCrash.visible = true 
			# 		$BulletCrash.play("hit_anim")
			# 		$snd_bullet_hit.play()	
						
			# 	if body_hit == true:
			# 		hit_target = true
			# 		if body_node.has_method("hit"):
			# 			body_node.hit()	
			# 		$BulletSprite.visible = false	
			# 		$BulletCrash.visible = true 
			# 		$BulletCrash.play("hit_anim")
			# 		$snd_bullet_hit.play()	

			#hit_target = true	 	
	



	#func _physics_process(delta):
		#Normal movement
		#if hit == false:
			#position += transform.x * speed * delta
		# else:
		# 	position += transform.x * speed * delta
			
		#if position.x > cursor_position.x and position.y > cursor_position.y:
		#position += transform.x * speed * delta
		#print(cursor_position)
		#if global_position.distance_to(cursor_position) < 200:	
			#Hit()
			
			#proces_penetrate2D()



	# func Hit():
	# 	if area_hit == true:
	# 		if area_node.has_method("hit"):
	# 			area_node.hit()
	# 			#$CollisionShape2D.set_deferred("disabled", true) 
	# 			$BulletSprite.visible = false
	# 			$BulletCrash.visible = true 
	# 			$BulletCrash.play("hit_anim")
	# 			$snd_bullet_hit.play()
	
	# 	if body_hit == true:
	# 		if body_node.has_method("hit"):
	# 			body_node.hit()
	# 			#$CollisionShape2D.set_deferred("disabled", true) 
	# 			$BulletSprite.visible = false
	# 			$BulletCrash.visible = true 
	# 			$BulletCrash.play("hit_anim")
	# 			$snd_bullet_hit.play()	







#$CollisionShape2D.disabled = true
	
	#if area.has_method("hit"):
		#area.hit()
	
	#if bulas == "Bullet":
		#hit = true
		#queue_free() 
		#$BulletSprite.visible = false
		#$BulletCrash.play("hit_anim")		
	
	#if bulas != "Bullet":
	#print("bullet hit Area2D: " + area.name)
		#hit = true
		#$BulletSprite.visible = false
		#$BulletCrash.play("hit_anim")
	#if area.is_in_group("Explosives"):
		#area.queue_free()
	#queue_free()  




#if body.is_in_group("Explosives"):
		#body.queue_free()

#func _on_bullet_crash_animation_finished():
	#if $BulletCrash.get_animation() == "hit_anim":
		#queue_free()
		#pass


# print("bullet hit Area2D: " + area.name)
	# String substr ( int from, int len=-1 )
	# String validate_node_name ( )
	# bullet hit Area2D: @Bullet@4
	# trim_prefix ( String prefix )
	# var bulas:String = area.name.substr ( 1,6 )
	#bulas = area.name
	#bulas = bulas.substr ( 0,6 )



#extends Area2D
#
#@export var speed = 3000
#
#func _ready():
#	pass 
#
#func _process(delta):
#	position += (Vector2.RIGHT * speed).rotated(rotation)*delta
#
#
#func _physics_process(delta):
#	await get_tree().create_timer(0.01).timeout	
#	set_physics_process(false)
#
#
#func _on_visible_on_screen_notifier_2d_screen_exited():
#	queue_free()
	
#func _on_body_entered(body):
	#queue_free()
















