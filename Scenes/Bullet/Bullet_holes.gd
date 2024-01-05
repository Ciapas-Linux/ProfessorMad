extends Node2D


@export var min_size : float = 0.5
@export var max_size : float = 2.3
@export var vanish_time := 0.5


var holes_position: Array[Vector2] = []
var holes_tmp_position: Vector2


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
	if holes_position.is_empty() == true: return

	holes_tmp_position = holes_position.pop_front()
	if get_node("../object_spr").is_pixel_opaque(holes_tmp_position) == true:
		var Bullet_Hit_sprite:Sprite2D = Sprite2D.new()
		#Bullet_Hit_sprite.texture = gv.Bullet_hit1_texure
		#Bullet_Hit_sprite.texture = gv.Bullet_hit_textures[randi() % len(gv.Bullet_hit_texures)]
		Bullet_Hit_sprite.texture = gv.Bullet_hit_textures.pick_random()
		var Sprite_scale:float = randf_range(min_size,max_size)
		Bullet_Hit_sprite.scale = Vector2(Sprite_scale,Sprite_scale)
		Bullet_Hit_sprite.position = holes_tmp_position
		visible = true
		add_child(Bullet_Hit_sprite)

	$snd_bullet_hit.play()	
			

func vanish() -> void:
	queue_free()









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
