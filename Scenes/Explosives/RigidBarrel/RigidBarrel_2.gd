extends RigidBody2D

# #################
# # RigidBarell_2 SCRIPT #
# #################

var hit_count: int
signal explode
@onready var tween: Tween
var Barrel_hit_tex:CompressedTexture2D = preload("res://Assets/Objects/beczka_damaged.png")
var timer: Timer

var mouse_enter:bool = false

func _ready():
	self.input_pickable = true
	self.connect("mouse_entered", _on_Area2D_mouse_entered)
	self.connect("mouse_exited", _on_Area2D_mouse_exited)
	hit_count = randi_range(1, 4)
	$Hitpoints.text = str(hit_count)
	$explosion_spr.visible = false
	$explosion_spr.stop()
	$object_spr.visible = true #head.texture = Head_hit1_img
	timer = Timer.new()
	add_child(timer)
	timer.set_one_shot(true)
	timer.set_wait_time(0.2)
	timer.connect("timeout", _timer_timeout)
	print("Node ready:" + self.name)

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
				print(node.collider.name)

func _on_Area2D_mouse_entered() -> void:
	mouse_enter = true
	
func _on_Area2D_mouse_exited() -> void:
	mouse_enter = false

func _process(_delta) -> void:
	pass

func _timer_timeout():
	position.y += 20

func _on_area_2d_area_entered(area: Area2D) -> void:
	print(name + ": area hit me " + area.name)

func _on_area_2d_body_entered(body: Node2D) -> void:
	hit()
	print(name + ": body hit me " + body.name)
	
func hit():
	if hit_count > 0:
		hit_count -= 1
		print(name + ": dostałam ! " + "hits: " + str(hit_count))
		$Bullet_holes.hit()
		position.y -= 30
		timer.start()
		$Hitpoints.text = str(hit_count)
		if hit_count == 0:
			barrel_explode(0)

func rpg_hit():
	barrel_explode(1)

func bomb_explode():
	barrel_explode(2)			

func _on_bodies_collision_hit_me() -> void:
	print(name + ": some bodies hits me")

func call_hit() -> void:
	# for child in get_parent().get_children():
	# 	if child is RigidBody2D:
	# 		print(name + ": XXX:Rigid body: " + child.name)
	# 		var distance : float = child.global_position.distance_to(global_position)
	# 		print(name + ": XXX:distance: " + str(int(distance)))
	# 		if child.has_method("rigid_barrel_explode"):
	# 			child.rigid_barrel_explode()

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


