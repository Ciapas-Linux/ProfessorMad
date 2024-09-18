extends Area2D

# #################
# # BOX2  .SCRIPT #
# #################



@onready var tween: Tween

var mouse_enter:bool = false
var hit_count:int
signal explode

func _ready():
	self.input_pickable = true
	self.connect("mouse_entered", _on_Area2D_mouse_entered)
	self.connect("mouse_exited", _on_Area2D_mouse_exited)
	hit_count = randi_range(1,4)
	$Hitpoints.text = str(hit_count)
	$explosion_spr.stop()
	$explosion_spr.visible = false
	$object_spr.visible = true
	
func _process(_delta) -> void:
	pass

func _on_Area2D_mouse_entered() -> void:
	mouse_enter = true
	if gv.Player.Player_current_weapon == 3:
		gv.set_cursor_green()
	#$object_spr.visible = false
	

func _on_Area2D_mouse_exited() -> void:
	mouse_enter = false
	if gv.Player.Player_current_weapon == 3:
		gv.set_cursor_orange()
	#$object_spr.visible = true

@warning_ignore("unused_parameter")
func _on_area_entered(area):
	pass

@warning_ignore("unused_parameter")	
func _on_body_entered(body: Node2D) -> void:
	pass 

func hit():
	if hit_count > 0:
			hit_count -= 1
			$Bullet_holes.hit()
			print("explosive_box2: dostałam ! " + "hits: " + str(hit_count))
			$Hitpoints.text = str(hit_count)
			if hit_count == 0:
				$BulletCollision.set_deferred("disabled", true)
				$Bullet_holes.vanish()
				$explosion_spr.visible = true
				$explosion_spr.play("explode")
				$snd_explode.play()
				gv.Cam1.ScreenShake(30,0.5)
				tween = get_tree().create_tween()
				tween.connect("finished", on_tween_finished)
				tween.set_ease(Tween.EASE_OUT)
				tween.set_trans(Tween.TRANS_SINE)
				tween.set_parallel(true)
				tween.tween_property($object_spr, "global_rotation", randf_range(-3.0,3.0), 1.2)
				tween.tween_property($object_spr, "global_position", Vector2(global_position.x + randf_range(-295.0,295.0), global_position.y - randf_range(105.0,275.0)), 1.6)
				tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 1.6)

func rpg_hit():
	$BodiesCollision/CollisionShape2D.set_deferred("disabled", true)
	$Bullet_holes.vanish()
	$explosion_spr.visible = true
	$explosion_spr.play("explode")
	$snd_explode.play()
	tween = get_tree().create_tween()
	tween.connect("finished", on_tween_finished)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	tween.tween_property($object_spr, "global_rotation", randf_range(-3.0,3.0), 1.3)
	tween.tween_property($object_spr, "global_position", Vector2(global_position.x + randf_range(-295.0,295.0), global_position.y - randf_range(105.0,275.0)), 1.6)
	tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 1.6)
	print(name + ": enemies hit me by rpg!") 

func F1_hit():
	bomb_explode()	

func bomb_explode():
	$BodiesCollision/CollisionShape2D.set_deferred("disabled", true)
	$Bullet_holes.vanish()
	$explosion_spr.visible = true
	$explosion_spr.play("explode")
	$snd_explode.play()
	tween = get_tree().create_tween()
	tween.connect("finished", on_tween_finished)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	tween.tween_property($object_spr, "global_rotation", randf_range(-4.0,3.0), 1.3)
	tween.tween_property($object_spr, "global_position", Vector2(global_position.x + randf_range(-295.0,295.0), global_position.y - randf_range(105.0,275.0)), 1.6)
	tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 1.6)
	print(name + ": enemies hit me by drone big bomb!") 

func _on_explosion_spr_animation_finished() -> void:
	emit_signal("explode")
	self.queue_free()
	#$explosion_spr.visible = false

func _on_bodies_collision_hit_me() -> void:
	print(name + ": on bodies collision!") 
	
func on_tween_finished():
	#emit_signal("explode")
	#self.queue_free()
	pass





# TRASH:
########

	
#func _on_body_entered(body):
#	print("skrzynka: dostałam !")
#	#pass # Replace with function body.

#	if "Bullet".is_subsequence_of(area.name):
#		if hit_count > 0:
#			hit_count -= 1
#			print("box2: dostałam ! od: " + area.name + " hits: " + str(hit_count))
#			$Hitpoints.text = str(hit_count)
#			if hit_count == 0:
#				$Sprite.play("explode")
#				$snd_explode.play()
#				ShakeScreen.shake(10,0.5)
