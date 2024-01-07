extends Node2D


@export var min_size : float = 0.5
@export var max_size : float = 2.3
@export var vanish_time := 0.5


var holes_position: Array[Vector2] = []
var holes_tmp_position: Vector2

# every new bullet send global signal we need conect to this signal:
func _ready() -> void:
	visible = false
	randomize() 
	gv.connect("player_bullet_ready",_on_player_bullet_ready)

func _process(_delta: float) -> void:
	pass

# Signal from bullet when enter to scene tree:
func _on_player_bullet_ready():
	if (get_owner().mouse_enter == true):
		holes_position.append(get_local_mouse_position())
		

## > (Vector2D),(Vector2D),(Vector2D),(Vector2D) ..........
func hit() -> void:
	if holes_position.is_empty() == true:
		print(name + ": empty array!") 
		return

	holes_tmp_position = holes_position.pop_front()
	var Bullet_Hit_sprite:Sprite2D = Sprite2D.new()
	Bullet_Hit_sprite.texture = gv.Bullet_hit_textures.pick_random()
	var Sprite_scale:float = randf_range(min_size,max_size)
	Bullet_Hit_sprite.scale = Vector2(Sprite_scale,Sprite_scale)
	Bullet_Hit_sprite.position = holes_tmp_position
	visible = true
	add_child(Bullet_Hit_sprite)
	$snd_bullet_hit.play()	
			

func vanish() -> void:
	queue_free()








##############################################
##############################################
############# RECYCLE       ##################
##############################################
##############################################
##############################################


# func hit(target_sprite : Sprite2D) -> void:

#if target_sprite.is_pixel_opaque(holes_tmp_position) == true:
	

#else:
	#	print(name + ": pixel transparent!?!") 	


#target_sprite.texture.lock()
	#print(target_sprite.get_data().get_pixel(holes_tmp_position))
	# var image = target_sprite.texture.get_image()
	# var color:Color  = image.get_pixelv(holes_tmp_position)
	# print(name + " : R" + str(color.r) + " : G" + str(color.g) + " : B" + str(color.b) )
	# print(name + str(holes_tmp_position)) 	
	#target_sprite.texture.unlock()



# func _ready():
#     var image = load("res://icon.png")
#     var data = image.get_data()
#     data.lock()
#     var pixel = data.get_pixel(1,2)
#     print(pixel)





# extends Sprite

# onready var area = $Area2D

# func _ready() -> void:
# 	area.connect('mouse_entered', self, '_on_mouse_entered')
# 	area.connect('mouse_exited', self, '_on_mouse_exited')

# 	var bitmap = BitMap.new()
# 	bitmap.create_from_image_alpha(texture.get_data())

# 	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, texture.get_size()))
# 	for poly in polys:
# 		var collision_polygon = CollisionPolygon2D.new()
# 		collision_polygon.polygon = poly
# 		area.add_child(collision_polygon)

# 		# Generated polygon will not take into account the half-width and half-height offset
# 		# of the image when "centered" is on. So move it backwards by this amount so it lines up.
# 		if centered:
# 			collision_polygon.position -= bitmap.get_size()/2

# func _on_mouse_entered() -> void:
# 	modulate = Color.red

# func _on_mouse_exited() -> void:
# 	modulate = Color.white









# export (NodePath) onready var my_camera = get_node(my_camera) as Camera





#if get_node("../object_spr").is_pixel_opaque(holes_tmp_position) == true:

#Bullet_Hit_sprite.texture = gv.Bullet_hit1_texure
		#Bullet_Hit_sprite.texture = gv.Bullet_hit_textures[randi() % len(gv.Bullet_hit_texures)]
	

#var local_cursor_position:Vector2

#@onready var tween: Tween



# holes_position.append(Vector2(x, y))



#parent = get_owner()

#if Input.is_action_just_pressed("Fire"):
#	local_cursor_position = get_local_mouse_position()	

#print("Bullet holes: bullet ready!")


#Bullet_sprite.visible = true w


#get_parent().add_child(Bullet_sprite)
#print("bullet hole: " + Bullet_sprite.name) 
#visible = true

#tween = get_tree().create_tween()
#tween.set_ease(Tween.EASE_OUT)
#tween.set_trans(Tween.TRANS_LINEAR) # or TRANS_LINEAR,TRANS_QUINT,TRANS_CUBIC,TRANS_BACK,TRANS_SINE
#tween.tween_property($object_spr, "self_modulate", Color(1, 1, 1, 0), vanish_time)
	


#local_cursor_position = get_local_mouse_position()
