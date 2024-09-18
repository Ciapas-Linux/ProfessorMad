extends RigidBody2D
# ##########################
# # RigidBox1           .SCRIPT #
# ##########################

@onready var tween: Tween
var hit_count:int
var mouse_enter:bool = false
var hit_anim_timer:Timer
var hit_anim_impulse:bool = false

func _ready():
	self.input_pickable = true
	self.connect("mouse_entered", _on_Area2D_mouse_entered)
	self.connect("mouse_exited", _on_Area2D_mouse_exited)
	hit_count = randi_range(1,4)
	$explode_spr.visible = false
	$explode_spr.stop()
	$Hitpoints.text = str(hit_count)
	$object_spr.visible = true

	hit_anim_timer = Timer.new()
	add_child(hit_anim_timer)
	hit_anim_timer.wait_time = 0.15
	hit_anim_timer.one_shot = true
	hit_anim_timer.connect("timeout", hit_anim_timer_timeout)

	print("Node ready:" + self.name)
	
func hit_anim_timer_timeout():
	hit_anim_impulse = false

func _process(_delta) -> void:
	pass

func _physics_process(_delta) -> void:
	if hit_anim_impulse == true:
		apply_impulse(Vector2(0, randf_range(-1200.0,-800.0)),Vector2(randf_range(-45.0,45.0),randf_range(-45.0,45.0)))

func _unhandled_input(event):
	if gv.Player.Player_current_weapon == 3:
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

func _on_area_2d_body_entered(body:Node2D) -> void:
	hit()
	print(name + ": body hit me " + body.name)

func _on_body_entered(body):
	if $snd_hit.playing == false:
		$snd_hit.play()
	print(name + ": body hit me " + body.name)

func call_hit() -> void:
	var nodes:Array[Node] = get_tree().get_nodes_in_group("shock_wave_hit")
	for node in nodes:
		#print(name + ": XXX:shock_wave_hit: " + node.name)
		if node.has_method("shock_wave_hit"):
			node.shock_wave_hit(self)
		#get_tree().call_group("shock_wave_hit", "shock_wave_hit")

func rpg_hit():
	call_hit()
	$Hitpoints.visible = false
	$Box1StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	gv.mouse_enter_node = null
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
	print(name + ": enemies finish me by rpg!") 

func hit():
	if hit_count > 0:
		print(name + ": dostałam od: " + "hits: " + str(hit_count))
		$Bullet_holes.hit()
		hit_count -= 1
		$Hitpoints.text = str(hit_count)
		hit_anim_timer.start()
		hit_anim_impulse = true

		if hit_count == 0:
			call_hit()
			$Hitpoints.visible = false
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

func F1_hit():
	bomb_explode()	

func bomb_explode():
	call_hit()
	$Hitpoints.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$Box1StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
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


	