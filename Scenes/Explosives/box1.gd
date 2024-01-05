# ##########################
# # Box1           .SCRIPT #
# ##########################

extends Area2D

@onready var tween: Tween
var hit_count:int

var mouse_enter:bool = false

func _ready():
	self.input_pickable = true
	self.connect("mouse_entered", _on_Area2D_mouse_entered)
	self.connect("mouse_exited", _on_Area2D_mouse_exited)
	hit_count = randi_range(1,4)
	$explode_spr.visible = false
	$explode_spr.stop()
	$Hitpoints.text = str(hit_count)
	$object_spr.visible = true
	
func _process(_delta) -> void:
	pass

func _on_Area2D_mouse_entered() -> void:
	mouse_enter = true
	#$object_spr.visible = false
    

func _on_Area2D_mouse_exited() -> void:
	mouse_enter = false
	#$object_spr.visible = true

@warning_ignore("unused_parameter")
func _on_area_entered(area):
	pass
	
@warning_ignore("unused_parameter")
func _on_body_entered(body):
	pass

func rpg_hit():
	$Bullet_holes.vanish()
	$explode_spr.visible = true
	$explode_spr.play("explode")
	$snd_explode.play()
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	tween.tween_property($object_spr, "global_rotation", randf_range(-5.0,5.0), 0.7)
	tween.tween_property($object_spr, "global_position", Vector2(global_position.x, global_position.y - 195), 0.7)
	tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 1.5)
	print(name + ": enemies hit me by rpg!") 

func hit():
	if hit_count > 0:
		print("box1: dostałam od: " + "hits: " + str(hit_count))
		$Bullet_holes.hit()
		hit_count -= 1
		$Hitpoints.text = str(hit_count)

		if hit_count == 0:
			$CollisionShape2D.set_deferred("disabled", true)
			$Bullet_holes.vanish()
			$explode_spr.visible = true
			$explode_spr.play("explode")
			$snd_explode.play()
			gv.Cam1.ScreenShake(30,0.5)	
			tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_SINE)
			tween.set_parallel(true)
			tween.tween_property($object_spr, "global_rotation", randf_range(-5.0,7.0), 0.7)
			tween.tween_property($object_spr, "global_position", Vector2(global_position.x, global_position.y - 165), 0.7)
			tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 1.5)
			print(name + ": enemies kill me by bullets!") 

func bomb_explode():
	$Bullet_holes.vanish()
	$explode_spr.visible = true
	$explode_spr.play("explode")
	$snd_explode.play()
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	tween.tween_property($object_spr, "global_rotation", randf_range(-6.0,5.0), 0.7)
	tween.tween_property($object_spr, "global_position", Vector2(global_position.x, global_position.y - 165), 0.7)
	tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 1.5)
	print(name + ": enemies hit me by drone big bomb!") 

func _on_explode_spr_animation_finished() -> void:
		self.queue_free()


	#if hit_count == 0 and $Sprite.is_playing() == false:
		#self.queue_free()
	#if Input.is_action_just_pressed("Fire"):
		#local_cursor_position = get_local_mouse_position()	






# Draw bullet holes
		#$Sprite.sprite_frames.get_frame_texture ( "idle", 0 ).is_pixel_opaque()
		#if $Sprite.sprite_frames.get_frame_texture( "default", 0 ).get_image.is_pixel_opaque(local_cursor_position) == true:
		# var Bullet_sprite:Sprite2D = Sprite2D.new()
		# Bullet_sprite.texture = gv.Bullet_hit1_texure
		# var Sprite_scale:float = randf_range(0.3,1.1)
		# Bullet_sprite.scale = Vector2(Sprite_scale,Sprite_scale)
		# Bullet_sprite.position = local_cursor_position 
		# add_child(Bullet_sprite)



#print(area.name)
	#  @Bullet@2
	#var str_name:String = area.name
	#str_name = str_name.lstrip()
	#if area.name.find("@Bul") != -1:




#if hit == true: return
	#pass
#	if area.name == "Bullet":
#		if $Sprite.is_playing() == true:
#			print("box1play: dostałam ! od: " + area.name + " hits: " + str(hit_count))
#			hit_count -= 1
#			return
#		hit_count -= 1
#		print("box1: dostałam ! od: " + area.name + " hits: " + str(hit_count))
#		if hit_count == 0:
#			$Sprite.play("explode")
#			$snd_explode.play()
	#self.queue_free()
	
#func _on_body_entered(body):
#	if body.name == "Bullet":
#		print("box1: dostałam od: " + body.name + " hits: " + str(hit_count))
#		$BulletCrash.position = body.position
#		$BulletCrash.play("hit_anim")
#		hit_count -= 1
#		$Sprite.play("explode")
#		$snd_explode.play()
	#pass # Replace with function body.


