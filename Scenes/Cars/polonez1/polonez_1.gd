extends RigidBody2D

@export var hit_count: int = 12

@onready var tween: Tween

var hit_texture:CompressedTexture2D = preload("res://Assets/Objects/polonez1_hit.png")
var timer: Timer


var mouse_enter:bool = false

func _ready() -> void:
	$object_spr.visible = true
	$BigExplosion.visible = false
	self.input_pickable = true
	self.connect("mouse_entered", _on_Area2D_mouse_entered)
	self.connect("mouse_exited", _on_Area2D_mouse_exited)
	timer = Timer.new()
	add_child(timer)
	timer.set_one_shot(true)
	timer.set_wait_time(0.2)
	timer.connect("timeout", _timer_timeout)

func _process(_delta: float) -> void:
	pass


func _timer_timeout():
	position.y += 20

func _on_Area2D_mouse_entered() -> void:
	mouse_enter = true
	#$object_spr.visible = false
	

func _on_Area2D_mouse_exited() -> void:
	mouse_enter = false
	#$object_spr.visible = true

func rpg_hit():
	print("polonez_1: dostałem od rpg")
	$CollisionPolygon2D.set_deferred("disabled", true)
	set_deferred("freeze", true)
	$snd_explode.play()
	#$ExplosionFx1.play("explode")
	$BigExplosion.explode()
	$BigExplosion.visible = true
	await get_tree().create_timer(0.3).timeout
	tween = get_tree().create_tween()
	#tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR) # or TRANS_LINEAR,TRANS_QUINT,TRANS_CUBIC,TRANS_BACK,TRANS_SINE
	tween.set_parallel(true)
	tween.tween_property($object_spr, "rotation", randf_range(-2.5, 2.5), 1.0)
	tween.tween_property($object_spr, "global_position", Vector2(global_position.x, global_position.y - 135), 0.9)
	tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 1.0)
	$object_spr.texture = hit_texture
	gv.Cam1.ScreenShake(50, 0.7)

func hit():
	if hit_count > 0:
		print("polonez_1: dostałem: " + "hits: " + str(hit_count))
		$Bullet_holes.hit()
		hit_count -= 1
		if hit_count == 0:
			$CollisionPolygon2D.set_deferred("disabled", true)
			set_deferred("freeze", true)
			$snd_explode.play()
			#$ExplosionFx1.play("explode")
			$BigExplosion.explode()
			$BigExplosion.visible = true
			await get_tree().create_timer(0.3).timeout
			$Bullet_holes.vanish()
			tween = get_tree().create_tween()
			#tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_LINEAR) # or TRANS_LINEAR,TRANS_QUINT,TRANS_CUBIC,TRANS_BACK,TRANS_SINE
			tween.set_parallel(true)
			tween.tween_property($object_spr, "rotation", randf_range(-2.5, 2.5), 1.0)
			tween.tween_property($object_spr, "global_position", Vector2(global_position.x, global_position.y - 135), 0.9)
			tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 1.0)
			$object_spr.texture = hit_texture
			gv.Cam1.ScreenShake(50, 0.7)


func bomb_explode():
	$Bullet_holes.vanish()
	$snd_explode.play()
	$BigExplosion.explode()
	$BigExplosion.visible = true
	#$ExplosionFx1.play("explode")
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR) # or TRANS_LINEAR,TRANS_QUINT,TRANS_CUBIC,TRANS_BACK,TRANS_SINE
	tween.set_parallel(true)
	tween.tween_property($object_spr, "rotation", randf_range(-2.5, 2.5), 0.9)
	tween.tween_property($object_spr, "global_position", Vector2(global_position.x, global_position.y - 65), 0.6)
	tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 0.9)
	$object_spr.texture = hit_texture
	print(name + ": enemies hit me by drone big bomb!")

func _on_area_entered(_area: Area2D) -> void:
	pass  # Replace with function body.

func _on_body_entered(_body: Node2D) -> void:
	pass  # Replace with function body.

func _on_explosion_fx_1_animation_finished() -> void:
	queue_free()


func _on_big_explosion_finished() -> void:
	queue_free()
