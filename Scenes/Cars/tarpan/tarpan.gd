extends CharacterBody2D

##############################################
# GDscript:									 #
# Tarpan ENEMIES Truck converted into combat #
#											 #	
##############################################



@export var hit_count:int = 12
@export var speed:float = 100
#@export var Gravity:float = 700.0
@onready var tween: Tween
var local_cursor_position:Vector2
var player_distance:float
const MOVE_RIGHT: int = 0
const MOVE_LEFT: int = 1
const STOP: int = 2
var mouse_enter:bool = false
var current_state : int = MOVE_LEFT

var particles_res:Resource = preload("res://Scenes/Cars/maluch/smoke_particles.tscn")
	
@onready var sounds:Array = [load("res://Assets/Sounds/pisk_opon1.wav"),
  	load("res://Assets/Sounds/pisk_opon2.wav"),
  	load("res://Assets/Sounds/pisk_opon3.wav")]
	
	
func _ready() -> void:
	self.input_pickable = true
	#self.connect("mouse_entered", _on_Area2D_mouse_entered)
	#self.connect("mouse_exited", _on_Area2D_mouse_exited)
	$BigExplosion.visible = false
	print("car Tarpan start x: " + str(global_position.x))
	start_drive()
	turn_left()

	

func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("Fire"):
		#local_cursor_position = get_local_mouse_position()
	pass	

func _physics_process(_delta) -> void:
	match current_state:
		STOP:
			_process_on_state_stop()
		MOVE_RIGHT:
			_process_on_state_move_right(_delta)
		MOVE_LEFT:
			_process_on_state_move_left(_delta)

func _process_on_state_stop() -> void:
		pass
	

func _on_mouse_entered() -> void:
	mouse_enter = true

func _on_mouse_exited() -> void:
	mouse_enter = false


func _tween():
	tween = get_tree().create_tween()
	#tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR) # or TRANS_LINEAR,TRANS_QUINT,TRANS_CUBIC,TRANS_BACK,TRANS_SINE
	tween.set_parallel(true)
	tween.tween_property($object_spr, "rotation", randf_range(-2.5, 2.5), 1.0)
	tween.tween_property($object_spr, "global_position", Vector2(global_position.x, global_position.y - 75), 0.9)
	tween.tween_property($Kolo_l, "global_position", Vector2(global_position.x - 70, global_position.y - 285), 0.6)
	tween.tween_property($Kolo_p, "global_position", Vector2(global_position.x + 120, global_position.y - 185), 0.6)
	tween.tween_property($Kolo_l, "rotation", randf_range(-4.5, 4.5), 0.9)
	tween.tween_property($Kolo_p, "rotation", randf_range(-4.5, 2.5), 0.4)
	tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 1.0)
	tween.tween_property($Kolo_l, "self_modulate", Color(1, 1, 1, 0), 1.0)
	tween.tween_property($Kolo_p, "self_modulate", Color(1, 1, 1, 0), 1.0)
	tween.tween_property($Driver, "self_modulate", Color(1, 1, 1, 0), 1.0)
	tween.tween_property($Boss, "self_modulate", Color(1, 1, 1, 0), 1.0)

func rpg_hit():
	$CollisionPolygon2D.set_deferred("disabled", true)
	$MaluchArea2D/CollisionPolygon2D.set_deferred("disabled", true)
	$BigExplosion.visible = true
	$BigExplosion.explode()
	$smoke_particles.emitting = false
	$smoke_particles.visible = false
	await get_tree().create_timer(0.3).timeout
	$Bullet_holes.vanish()
	current_state = STOP
	get_node("snd_engine").stop()
	$snd_player.stop()
	_tween()


func bomb_explode():
	$CollisionPolygon2D.set_deferred("disabled", true)
	$MaluchArea2D/CollisionPolygon2D.set_deferred("disabled", true)
	$BigExplosion.visible = true
	$BigExplosion.explode()
	$smoke_particles.emitting = false
	$smoke_particles.visible = false
	await get_tree().create_timer(0.3).timeout
	$Bullet_holes.vanish()
	current_state = STOP
	get_node("snd_engine").stop()
	$snd_player.stop()
	_tween()

func hit()-> void:
	if hit_count > 0:
		print("Tarpan boss: dostałem: " + "hits: " + str(hit_count))
		$Bullet_holes.hit()
		hit_count -= 1
		
		if hit_count == 0:
			$CollisionPolygon2D.set_deferred("disabled", true)
			$MaluchArea2D/CollisionPolygon2D.set_deferred("disabled", true)
			$BigExplosion.explode()
			$BigExplosion.visible = true
			$smoke_particles.emitting = false
			$smoke_particles.visible = false
			await get_tree().create_timer(0.3).timeout
			$Bullet_holes.vanish()
			current_state = STOP
			get_node("snd_engine").stop()
			$snd_player.stop()
			_tween()
			gv.Cam1.ScreenShake(30,0.5)
			#queue_free()	
		
	
func turn_left() -> void:
	scale.x = scale.y * -1
	$smoke_particles.gravity = Vector2(500.0, 2.0)
	current_state = MOVE_LEFT


func turn_right() -> void:
	scale.x = scale.y * 1
	$smoke_particles.gravity = Vector2(-500.0, 2.0)
	current_state = MOVE_RIGHT	

func stop_drive() -> void:
		current_state = STOP
		$Kolo_l/AnimationPlayer.stop(true)
		$Kolo_p/AnimationPlayer.stop(true)
		$Driver/AnimationPlayer.play("RESET")
		#$Boss/AnimationPlayer.play("RESET")
		get_node("snd_engine").stop()

func start_drive() -> void:
	if $smoke_particles.emitting == false:
			$smoke_particles.emitting = true
	
	if $Kolo_l/AnimationPlayer.is_playing() == false:
		$Kolo_l/AnimationPlayer.play("rotate")
		
	if $Kolo_p/AnimationPlayer.is_playing() == false:
		$Kolo_p/AnimationPlayer.play("rotate")
	
	if $Driver/AnimationPlayer.is_playing() == false:
		$Driver/AnimationPlayer.play("head_rotate")
		
	#if $Boss/AnimationPlayer.is_playing() == false:
		#$Boss/AnimationPlayer.play("rotate")	
		
	if get_node("snd_engine").playing != true:
			get_node("snd_engine").play()


func start_talk():
	if $Driver.is_playing() == false:
		$Driver.play("talk")


func stop_talk():
	$Driver.stop()


func _process_on_state_move_right(_delta: float) -> void:
	velocity.x = speed
	#velocity.y += gravity * delta
	player_distance = global_position.distance_to(gv.Hero_global_position)
	move_and_slide()
	

@warning_ignore("unused_parameter")	
func _process_on_state_move_left(delta: float) -> void:
	velocity.x = -speed
	#velocity.y += gravity * delta
	player_distance = global_position.distance_to(gv.Hero_global_position)
	move_and_slide()		
		

func _on_timer_timeout() -> void:
	speed = randf_range(10.0,800.0)
	if speed < 50 or speed > 300:
		$snd_player.stream = sounds[randi() % len(sounds)]
		if $snd_player.playing != true:
			$snd_player.play()
	

func _on_front_contact_area_entered(area:Area2D) -> void:
	print("Tarpan, hit area: " + area.name)
	match current_state:
		STOP:
			pass
		MOVE_RIGHT:
			turn_left()
		MOVE_LEFT:
			turn_right()
			

func _on_big_explosion_finished() -> void:
	queue_free() 




# if global_position.x < randi_range(200,600):
# 		current_state = MOVE_RIGHT
# 		$Kolo_l/AnimationPlayer.stop(true)
# 		$Kolo_p/AnimationPlayer.stop(true)
# 		$Driver/AnimationPlayer.play("RESET")
# 		$Boss/AnimationPlayer.play("RESET")
# 		scale.x = scale.y * 1
# 		$smoke_particles.gravity = Vector2(-500.0, 2.0)
# 		$smoke_particles.emitting = false
# 		if get_node("snd_engine").playing == true:
# 			get_node("snd_engine").stop()



# if global_position.x > randi_range(8000,9000):
# 		current_state = MOVE_LEFT
# 		$Kolo_l/AnimationPlayer.stop(true)
# 		$Kolo_p/AnimationPlayer.stop(true)
# 		$Driver/AnimationPlayer.play("RESET")
# 		#$Boss/AnimationPlayer.play("RESET")
# 		scale.x = scale.y * -1
# 		$smoke_particles.gravity = Vector2(500.0, 2.0)
# 		$smoke_particles.emitting = false
# 		if get_node("snd_engine").playing == true:
# 			get_node("snd_engine").stop()





#$object_spr.visible = false
			#$explode_spr.play("explode")
			#$snd_explode.play()
			#ShakeScreen.shake(20,0.5)






	# if (area.name.contains("Bullet") == true):
	# 	if $Body.is_pixel_opaque(local_cursor_position) == true:
	# 		var Bullet_sprite:Sprite2D = Sprite2D.new()
	# 		Bullet_sprite.texture = gv.Bullet_hit1_texure
	# 		var Sprite_scale:float = randf_range(0.3,1.1)
	# 		Bullet_sprite.scale = Vector2(Sprite_scale,Sprite_scale)
	# 		Bullet_sprite.position = local_cursor_position 
	# 		add_child(Bullet_sprite)
		






#Bullet_hit1_tex.draw($Body.texture,Vector2(100,100),Color(1,1,1),false)
#$Body.draw(Bullet_hit1_tex,Vector2(100,100),Color(1,1,1),false)
#$Body.texture.draw(Bullet_hit1_tex,Vector2(100,100),Color(1,1,1),false)
#$Body.image.blit_rect(Bullet_hit1_tex,Rect2i(0,0,100,100),Vector2(30,30))

#Bullet_hit1_tex = Image.new()
#Bullet_hit1_tex.load("res://Assets/Particles/bullet-holes/bullet-hole1-sm.png")
#Bullet_hit1_tex = Image.load_from_file("res://Assets/Particles/bullet-holes/bullet-hole1-sm.png")
	
	








