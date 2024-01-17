extends Area2D

@export var speed = 4200
var area_hit:bool = false
var hit:bool = false
#var area_node:Node2D
#var body_node:Node2D
# var bulas:String
var cursor_position:Vector2
var distance_to_target:float
var t:float = 0.0

func _ready():
	$BulletCrash.stop()
	$BulletCrash.visible = false
	#area_hit = false
	#body_hit = false
	cursor_position = get_global_mouse_position()
	#cursor_position.x -= 50
	#cursor_position.y -= 0
	distance_to_target = global_position.distance_to(cursor_position)
	print("Player bullet name: " + self.name)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.connect("finished",tween_finished)
	#tween.tween_property(self, "position", cursor_position, 0.5)
	

func tween_finished():
	$BulletSprite.visible = false
	$BulletCrash.visible = true 
	$BulletCrash.play("hit_anim")

func _physics_process(delta):
	
	t += delta * 0.5
	global_position = global_position.lerp(cursor_position,t)
			
	pass

	
	
func _on_area_entered(area):
	print("Player bullet hit Area2D: " + area.name)
	#area_node = area
	if area.has_method("hit"):
		area.hit()
	hit = true
	# $CollisionShape2D.disabled = true
	$CollisionShape2D.set_deferred("disabled", true) 
	$BulletSprite.visible = false
	$BulletCrash.visible = true 
	$BulletCrash.play("hit_anim")
	$snd_bullet_hit.play()
	

func _on_body_entered(body):
	print("bullet hit Body: " + body.name)
	#body_node = body
	hit = true
	# $CollisionShape2D.disabled = true
	$CollisionShape2D.set_deferred("disabled", true)  
	$BulletSprite.visible = false
	$BulletCrash.visible = true 
	$BulletCrash.play("hit_anim")
	$snd_bullet_hit.play()
	if body.has_method("hit"):
		body.hit()	
		

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_bullet_crash_animation_finished() -> void:
	queue_free()





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












