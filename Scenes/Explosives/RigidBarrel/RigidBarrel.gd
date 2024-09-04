extends RigidBody2D

# #################
# # RigidBarell_2 SCRIPT #
# #################

var hit_count: int
signal explode
@onready var tween: Tween
var Barrel_hit_tex:CompressedTexture2D = preload("res://Assets/Explosives/Barrel/beczka_damaged.png")

var mouse_enter:bool = false

var hit_anim_timer:Timer
var hit_anim_impulse:bool = false
var hit_anim_direction:Vector2 = Vector2.RIGHT

func _ready():
	self.input_pickable = true
	self.connect("mouse_entered", _on_Area2D_mouse_entered)
	self.connect("mouse_exited", _on_Area2D_mouse_exited)
	hit_count = randi_range(1, 4)
	$Hitpoints.text = str(hit_count)
	$explosion_spr.visible = false
	$explosion_spr.stop()
	$object_spr.visible = true #head.texture = Head_hit1_img
	hit_anim_timer = Timer.new()
	add_child(hit_anim_timer)
	hit_anim_timer.wait_time = 0.15
	hit_anim_timer.one_shot = true
	hit_anim_timer.connect("timeout", hit_anim_timer_timeout)
	print("Node ready:" + self.name)

func hit_anim_timer_timeout():
	hit_anim_impulse = false

func _unhandled_input(event):
	if gv.Player.Player_current_weapon == gv.Player.Player_guns["rocket_4"]:
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
				print("Mouse collision: " + node.collider.name)

func _on_Area2D_mouse_entered() -> void:
	mouse_enter = true
	
func _on_Area2D_mouse_exited() -> void:
	mouse_enter = false

func _physics_process(_delta) -> void:
	if hit_anim_impulse == true:
		apply_impulse(Vector2(0, -3810),Vector2(randf_range(-45.0,45.0),randf_range(-45.0,45.0)))

func _process(_delta) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	print(name + ": area hit me: " + area.name)

func _on_area_2d_body_entered(body: Node2D) -> void:
	hit()
	print(name + ": body hit me: " + body.name)
	
func _on_body_entered(body:Node) -> void:
	if $snd_hit.playing == false:
		$snd_hit.play()
	print(name + ": body entered: " + body.name)

func hit():
	if hit_count > 0:
		hit_count -= 1
		print(name + ": got hit " + "hits: " + str(hit_count))
		$Bullet_holes.hit()
		$Hitpoints.text = str(hit_count)
		hit_anim_timer.start()
		hit_anim_impulse = true

		if hit_count == 0:
			barrel_explode(0)

func rpg_hit():
	barrel_explode(1)

func bomb_explode():
	barrel_explode(2)			

func call_hit() -> void:
	var nodes:Array[Node] = get_tree().get_nodes_in_group("shock_wave_hit")
	for node in nodes:
		#print(name + ": XXX:shock_wave_hit: " + node.name)
		if node.has_method("shock_wave_hit"):
			node.shock_wave_hit(self)
		#get_tree().call_group("shock_wave_hit", "shock_wave_hit")


# type: 0: gun, 1: rpg, 2: bomb
func barrel_explode(_type:int) -> void:
	call_hit()
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	$Bullet_holes.vanish()
	$explosion_spr.visible = true
	$explosion_spr.play("explode")
	$snd_explode.play()
	gv.Cam1.ScreenShake(30, 0.5)
	
	match	_type:
		0:
			tween = get_tree().create_tween()
			tween.connect("finished", on_tween_finished)
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_LINEAR)
			tween.set_parallel(true)
			tween.tween_property($object_spr, "global_rotation", randf_range(-3.0,3.0), 1)
			tween.tween_property($object_spr, "global_position", Vector2(global_position.x, global_position.y - randf_range(150,200)), 1)
			tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 1.2)
			print(name + ": enemies finish me by gun or hit!")
		1:
			tween = get_tree().create_tween()
			tween.connect("finished", on_tween_finished)
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_SINE)
			tween.set_parallel(true)
			tween.tween_property($object_spr, "global_rotation", randf_range(-4.0,4.0), 1.4)
			tween.tween_property($object_spr, "global_position", Vector2(global_position.x + randf_range(-300.0,400.0), global_position.y - randf_range(300.0,400.0)), 1.2)
			tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 2.1)
			print(name + ": enemies finish me by rpg!")
		2:
			tween = get_tree().create_tween()
			tween.connect("finished", on_tween_finished)
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_SINE)
			tween.set_parallel(true)
			tween.tween_property($object_spr, "global_rotation", randf_range(-3.0,3.0), 0.7)
			tween.tween_property($object_spr, "global_position", Vector2(global_position.x, global_position.y - 165), 0.7)
			tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), 1.5)
			print(name + ": enemies finish me by drone bomb!")	

	$object_spr.texture = Barrel_hit_tex


func _on_explosion_spr_animation_finished() -> void:
	#emit_signal("explode")
	#self.queue_free()
	pass

func on_tween_finished():
	emit_signal("explode")
	self.queue_free()
