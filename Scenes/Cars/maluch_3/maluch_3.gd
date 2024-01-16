
extends Area2D

@onready var tween: Tween
var hit_count:int

signal explode

var mouse_enter:bool = false

func _ready():
	randomize() 
	self.input_pickable = true
	self.connect("mouse_entered", _on_Area2D_mouse_entered)
	self.connect("mouse_exited", _on_Area2D_mouse_exited)
	hit_count = randi_range(5,15)
	$explosion_spr.stop()
	$explosion_spr.visible = false
	$Hitpoints.text = str(hit_count)
	$object_spr.visible = true
	
func _process(_delta) -> void:
	pass

func _unhandled_input(event):
	if gv.Hero_current_weapon == gv.Hero_guns["rocket_4"]: # only for rocket_4
		if event.is_action_pressed("mouse_left_click") && mouse_enter: 
			# do here whatever should happen when you click on that node:
			gv.mouse_enter_node = self
			print(self.name + ": left mouse click me!")
			$snd_click.play() 
			get_viewport().set_input_as_handled()
			gv.set_cursor_red()
			var space_state = get_world_2d().direct_space_state
			var params = PhysicsPointQueryParameters2D.new()
			params.position = get_global_mouse_position()
			var out = space_state.intersect_point(params)
			for node in out:
				print(node.collider.name)
		
func _on_Area2D_mouse_entered() -> void:
	mouse_enter = true
		
func _on_Area2D_mouse_exited() -> void:
	mouse_enter = false
	
@warning_ignore("unused_parameter")
func _on_area_entered(area):
	pass
	
@warning_ignore("unused_parameter")
func _on_body_entered(body):
	pass

func _tween():
	tween = get_tree().create_tween()
	tween.connect("finished", on_tween_finished)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	
	tween.tween_property($Kolo_l, "global_rotation", randf_range(-5.0,5.0), 1.2)
	tween.tween_property($Kolo_l, "global_position", Vector2(global_position.x + randf_range(-205.0,305.0), global_position.y - randf_range(300.0,505.0)), 1.7)
	tween.tween_property($Kolo_l, "self_modulate", Color(1, 1, 1, 0), 2.3)
	
	tween.tween_property($Kolo_p, "global_rotation", randf_range(-5.0,5.0), 0.7)
	tween.tween_property($Kolo_p, "global_position", Vector2(global_position.x + randf_range(-275.0,375.0) , global_position.y - randf_range(300.0,575.0)), 1.8)
	tween.tween_property($Kolo_p, "self_modulate", Color(1, 1, 1, 0), 2.5)
	
	tween.tween_property($buda_tyl, "global_rotation", randf_range(-5.0,5.0), 0.5)
	tween.tween_property($buda_tyl, "global_position", Vector2(global_position.x + randf_range(-275.0,375.0), global_position.y - randf_range(125.0,375.0)), 1.5)
	tween.tween_property($buda_tyl, "self_modulate", Color(1, 1, 1, 0), 2.6)
	
	tween.tween_property($dach, "global_rotation", randf_range(-5.0,5.0), 1.2)
	tween.tween_property($dach, "global_position", Vector2(global_position.x + randf_range(-375.0,375.0), global_position.y - randf_range(75.0,375.0)), 2.1)
	tween.tween_property($dach, "self_modulate", Color(1, 1, 1, 0), 2.4)
	
	tween.tween_property($drzwi, "global_rotation", randf_range(-5.0,5.0), 1.1)
	tween.tween_property($drzwi, "global_position", Vector2(global_position.x + randf_range(-375.0,375.0), global_position.y - randf_range(125.0,375.0)), 1.9)
	tween.tween_property($drzwi, "self_modulate", Color(1, 1, 1, 0), 2.9)
	
	tween.tween_property($lampa_tyl, "global_rotation", randf_range(-5.0,5.0), 0.5)
	tween.tween_property($lampa_tyl, "global_position", Vector2(global_position.x + randf_range(-305.0,355.0), global_position.y - randf_range(185.0,205.0)), 2.1)
	tween.tween_property($lampa_tyl, "self_modulate", Color(1, 1, 1, 0), 2.5)
	
	tween.tween_property($maska_p, "global_rotation", randf_range(-5.0,5.0), 1.2)
	tween.tween_property($maska_p, "global_position", Vector2(global_position.x + randf_range(-395.0,295.0), global_position.y - randf_range(105.0,375.0)), 1.6)
	tween.tween_property($maska_p, "self_modulate", Color(1, 1, 1, 0), 2.9)
	
	tween.tween_property($podloga, "global_rotation", randf_range(-5.0,5.0), 0.9)
	tween.tween_property($podloga, "global_position", Vector2(global_position.x + randf_range(-305.0,305.0), global_position.y - randf_range(85.0,335.0)), 2.3)
	tween.tween_property($podloga, "self_modulate", Color(1, 1, 1, 0), 2.3)
	
	tween.tween_property($przod_p, "global_rotation", randf_range(-5.0,5.0), 0.9)
	tween.tween_property($przod_p, "global_position", Vector2(global_position.x + randf_range(-305.0,305.0), global_position.y - randf_range(85.0,335.0)), 2.0)
	tween.tween_property($przod_p, "self_modulate", Color(1, 1, 1, 0), 2.5)
	
	tween.tween_property($szyba_p, "global_rotation", randf_range(-5.0,5.0), 0.9)
	tween.tween_property($szyba_p, "global_position", Vector2(global_position.x + randf_range(-305.0,305.0), global_position.y - randf_range(85.0,335.0)), 1.8)
	tween.tween_property($szyba_p, "self_modulate", Color(1, 1, 1, 0), 2.7)
	
	tween.tween_property($szyba_tyl, "global_rotation", randf_range(-5.0,5.0), 0.9)
	tween.tween_property($szyba_tyl, "global_position", Vector2(global_position.x + randf_range(-305.0,305.0), global_position.y - randf_range(85.0,335.0)), 2.6)
	tween.tween_property($szyba_tyl, "self_modulate", Color(1, 1, 1, 0), 2.5)
	
func rpg_hit():
	gv.mouse_enter_node = null
	$Bullet_holes.vanish()
	$object_spr.visible = false
	$explosion_spr.visible = true
	$snd_explode.play()
	$explosion_spr.play("explode")
	$Hitpoints.visible = false
	_tween()
	gv.Cam1.ScreenShake(30,0.5)	
	print(name + ": enemies hit me by rpg!") 

func hit():
	if hit_count > 0:
		print(name + ": player bullet hit me" + " hits: " + str(hit_count))
		$Bullet_holes.hit()
		hit_count -= 1
		$Hitpoints.text = str(hit_count)

		if hit_count == 0:
			$CollisionPolygon2D.set_deferred("disabled", true)
			$Bullet_holes.vanish()
			$object_spr.visible = false
			$Hitpoints.visible = false
			$explosion_spr.visible = true
			$explosion_spr.play("explode")
			$snd_explode.play()
			_tween()
			gv.Cam1.ScreenShake(30,0.5)	
			print(name + ": enemies kill me by bullets!") 

func bomb_explode():
	$Bullet_holes.vanish()
	$object_spr.visible = false
	$Hitpoints.visible = false
	$explosion_spr.visible = true
	$explosion_spr.play("explode")
	$snd_explode.play()
	_tween()
	print(name + ": enemies hit me by drone big bomb!") 

func on_tween_finished():
	emit_signal("explode")
	self.queue_free()

func _on_explosion_spr_animation_finished() -> void:
	$explosion_spr.visible = false
	


################################################################

#if gv.Hero_current_weapon == gv.Hero_guns["rocket_4"]:
		#gv.set_cursor_orange()
		#gv.mouse_enter_node = null
	#$object_spr.visible = true

#if gv.Hero_current_weapon == gv.Hero_guns["rocket_4"]:
		#gv.set_cursor_green()
		# gv.mouse_enter_node = self
		# gv.emit_signal("s_mouse_enter_node",self)
	#$object_spr.visible = false

# extends Area2D

# func _input_event(viewport, event, shape_idx):
#     if event.type == InputEvent.MOUSE_BUTTON \
#     and event.button_index == BUTTON_LEFT \
#     and event.pressed:
#         print("Clicked")
#         return(self) # returns a reference to this node







# var mouse_entered = false

# func _unhandled_input(event):
# 	if event.is_action_pressed("mouse_left_click") && \
# 	mouse_entered:
# 		# do here whatever should happen when you click on that node
# 		self.get_tree().set_input_as_handled()

# func _on_Area2D_mouse_entered():
# 	mouse_entered = true

# func _on_Area2D_mouse_exited():
# 	mouse_entered = false



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


