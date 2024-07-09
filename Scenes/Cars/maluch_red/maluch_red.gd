extends Area2D

@export var hit_count: int = 12

@onready var tween: Tween
#var blast_up_timer: Timer

var mouse_enter:bool = false

func _ready() -> void:
	$object_spr.visible = true
	self.input_pickable = true
	self.connect("mouse_entered", _on_Area2D_mouse_entered)
	self.connect("mouse_exited", _on_Area2D_mouse_exited)

func _on_Area2D_mouse_entered() -> void:
	mouse_enter = true
	if gv.Player.Player_current_weapon == gv.Player.Player_guns["rocket_4"]:
		gv.set_cursor_green()
	#$object_spr.visible = false
	

func _on_Area2D_mouse_exited() -> void:
	mouse_enter = false
	if gv.Player.Player_current_weapon == gv.Player.Player_guns["rocket_4"]:
		gv.set_cursor_orange()
	#$object_spr.visible = true	

func _on_timer_timeout():
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "rotation", randf_range(-0.5, 0.5), 0.2)
	tween.tween_property(
		self, "global_position", Vector2(global_position.x, global_position.y - 55), 0.4
	)
	tween.tween_property(
		self, "global_position", Vector2(global_position.x, global_position.y + 15), 0.3
	)
	tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 1.0)


func _process(_delta: float) -> void:
	pass

func rpg_hit():
	$CollisionPolygon2D.set_deferred("disabled", true)
	$Bullet_holes.vanish()
	$snd_explode.play()
	$ExplosionFx1.play("explode")
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR) # or TRANS_LINEAR,TRANS_QUINT,TRANS_CUBIC,TRANS_BACK,TRANS_SINE
	tween.set_parallel(true)
	tween.tween_property($object_spr, "rotation", randf_range(-2.5, 2.5), 0.9)
	tween.tween_property($object_spr, "global_position", Vector2(global_position.x, global_position.y - 65), 0.6)
	tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 0.9)
	tween.tween_property($Kolo_l, "self_modulate", Color(1, 1, 1, 0), 1.0)
	tween.tween_property($Kolo_p, "self_modulate", Color(1, 1, 1, 0), 1.0)
	tween.tween_property($Kolo_l, "global_position", Vector2(global_position.x - 70, global_position.y - 285), 0.6)
	tween.tween_property($Kolo_p, "global_position", Vector2(global_position.x + 120, global_position.y - 185), 0.6)
	tween.tween_property($Kolo_l, "rotation", randf_range(-4.5, 4.5), 0.9)
	tween.tween_property($Kolo_p, "rotation", randf_range(-4.5, 2.5), 0.4)
	gv.Cam1.ScreenShake(40, 0.6)

func hit():
	if hit_count > 0:
		print("maluch red: dostałem: " + "hits: " + str(hit_count))
		$Bullet_holes.hit()
		hit_count -= 1

		if hit_count == 0:
			$CollisionPolygon2D.set_deferred("disabled", true)
			$Bullet_holes.vanish()
			$snd_explode.play()
			$ExplosionFx1.play("explode")
			tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_LINEAR) # or TRANS_LINEAR,TRANS_QUINT,TRANS_CUBIC,TRANS_BACK,TRANS_SINE
			tween.set_parallel(true)
			tween.tween_property($object_spr, "rotation", randf_range(-2.5, 2.5), 0.9)
			tween.tween_property($object_spr, "global_position", Vector2(global_position.x, global_position.y - 65), 0.6)
			tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 0.9)
			tween.tween_property($Kolo_l, "self_modulate", Color(1, 1, 1, 0), 1.0)
			tween.tween_property($Kolo_p, "self_modulate", Color(1, 1, 1, 0), 1.0)
			tween.tween_property($Kolo_l, "global_position", Vector2(global_position.x - 70, global_position.y - 285), 0.6)
			tween.tween_property($Kolo_p, "global_position", Vector2(global_position.x + 120, global_position.y - 185), 0.6)
			tween.tween_property($Kolo_l, "rotation", randf_range(-4.5, 4.5), 0.9)
			tween.tween_property($Kolo_p, "rotation", randf_range(-4.5, 2.5), 0.4)
			gv.Cam1.ScreenShake(30, 0.5)


func on_tween_finished():
	pass


func bomb_explode():
	$CollisionPolygon2D.set_deferred("disabled", true)
	$Bullet_holes.vanish()
	$ExplosionFx1.play("explode")
	$snd_explode.play()
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	tween.tween_property($object_spr, "rotation", randf_range(-0.5, 0.5), 0.4)
	tween.tween_property($object_spr, "global_position", Vector2(global_position.x, global_position.y - 55), 0.4)
	tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 0.9)
	tween.tween_property($Kolo_l, "self_modulate", Color(1, 1, 1, 0), 1.0)
	tween.tween_property($Kolo_p, "self_modulate", Color(1, 1, 1, 0), 1.0)
	tween.tween_property($Kolo_l, "global_position", Vector2(global_position.x - 70, global_position.y - 285), 0.6)
	tween.tween_property($Kolo_p, "global_position", Vector2(global_position.x + 120, global_position.y - 185), 0.6)
	tween.tween_property($Kolo_l, "rotation", randf_range(-4.5, 4.5), 0.9)
	tween.tween_property($Kolo_p, "rotation", randf_range(-4.5, 2.5), 0.4)
	print(name + ": enemies hit me by drone big bomb!")


func _on_area_entered(_area: Area2D) -> void:
	pass 


func _on_body_entered(_body: Node2D) -> void:
	pass 


func _on_explosion_fx_1_animation_finished() -> void:
	queue_free()







#blast_up_timer = Timer.new()
#add_child(blast_up_timer)
#blast_up_timer.wait_time = 0.3
#blast_up_timer.connect("timeout", _on_timer_timeout)
#blast_up_timer.one_shot = true
#tween = get_tree().create_tween()
#add_child(tween)

#tween.tween_property($object_spr, "modulate.a", 0.0, 0.65)
#tween.interpolate_property(self, "modulate",Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2.0,Tween.TRANS_LINEAR, Tween.EASE_IN)
#tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 0.7)
#tween.set_trans(Tween.TRANS_QUART)
#tween.set_active(true)





#tween.connect("finished", on_tween_finished)


#if "Bullet".is_subsequence_of(area.name):

#$object_spr.visible = false



#tween = create_tween()

#tween.connect("finished", on_tween_finished)

#tween.tween_property(self, "rotation", randf_range(-0.5,0.5), 0.2)

#tween.stop()
#tween.tween_property(self, "global_position", Vector2( global_position.x, global_position.y + 35 ), 0.3)
		
#tween.tween_callback(fall_down)

#blast_up_timer.start()

#$snd_explode.play()
#ShakeScreen.shake(20,0.5)


#tween.tween_property($ExplosionFx1, "global_position", Vector2( global_position.x, global_position.y - 65 ), 2.4)
#tween.tween_property(self, "global_position", Vector2( global_position.x, global_position.y + 15 ), 0.3)
	
