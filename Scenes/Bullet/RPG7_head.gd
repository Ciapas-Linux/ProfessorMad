extends Area2D

@export var speed:float = 0.0008 # 0.0008
@export var continue_speed:float = 2500
var distance:float = 0.0
var actual_distance:float = 0.0
var destination_point:Vector2
var start_point:Vector2
var hit:bool = false
var continue_move :bool = false
# var yacceleration:int = 0
var timer :Timer


func _enter_tree() -> void:
	destination_point = get_global_mouse_position()
	
	

func _ready():
	start_point =  global_position
	distance = global_position.distance_to(destination_point)
	$sprite_flame.visible = true
	$sprite_flame.play()
	$hit_sprite.visible = false
	#$hit_sprite.position = destination_point
	$CollisionShape2D.disabled = true
	timer = Timer.new()
	timer.wait_time = 0.05
	timer.one_shot = true
	timer.connect("timeout", _on_timer_timeout)
	add_child(timer)
	var tween = create_tween()
	tween.connect("finished", on_tween_finished)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", destination_point, distance * speed)
	$snd_fire1.play()
	$snd_fire2.play()
	
	# print("")
	print("Player release rpg head: " + self.name)
	# print("Player release rpg head m viewport: " + str(get_viewport().get_mouse_position()))
	# print("Player release rpg head m global: " + str(get_global_mouse_position()))
	# print("Player release rpg head m local: " + str(get_local_mouse_position()))
	# print("Player release rpg head Start: " + str(start_point))
	# print("Player release rpg head Distance: " + str(distance))
	# print("Player release rpg head Destination: " + str(destination_point))
	# print("Player release rpg head Distance 2: " + str(destination_point - start_point))
	# print("")



func _physics_process(delta):
	# actual_distance = global_position.distance_to(destination_point)
	# $RayCast2D.target_position = get_local_mouse_position()	
	# print("rpg dist: " + str(int(actual_distance)))
	if continue_move == true and hit == false:# rocket miss target just continue fly that direction:
		position += transform.x * continue_speed * delta
		#yacceleration += 1
		#position.y -= yacceleration
		

# when rocket go to destination point:
func on_tween_finished():
	$CollisionShape2D.disabled = false
	continue_move = true
	$snd_continue.play()
	timer.start()
	print("rpg: continue movement")

# after few frames disable collision detection:		
func _on_timer_timeout() -> void:
	$CollisionShape2D.disabled = true
	
			
func _on_area_entered(area):
	print("Player rpg hit Area2D: " + area.name)
	if area.has_method("rpg_hit"):
		area.rpg_hit()
	$snd_continue.stop()
	$snd_fire2.stop()		
	$RPG_sprite.visible = false
	$sprite_flame.visible = false
	$hit_sprite.visible = true
	$hit_sprite.play("explode")
	hit = true		
				
func _on_body_entered(body):
	print("Player rpg hit Body: " + body.name)
	if body.has_method("rpg_hit"):
		body.rpg_hit()
	$snd_continue.stop()
	$snd_fire2.stop()	
	$RPG_sprite.visible = false
	$sprite_flame.visible = false
	$hit_sprite.visible = true
	$hit_sprite.play("explode")				
	hit = true		
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_hit_sprite_animation_finished() -> void:
	queue_free()




#continue_move = true
	#monitorable = false
	#monitoring = false
	#print("@@@@@@@@@@@@@@@@: timeout")
	#pass


# var mils = Time.get_ticks_msec()

#gv.emit_signal("player_bullet_ready")

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


















