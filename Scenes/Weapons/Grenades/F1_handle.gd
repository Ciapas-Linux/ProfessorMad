extends Sprite2D

const ammo_max:int = 15
var ammo:int = ammo_max

@onready var anim_player : AnimationPlayer = gv.Player.get_node("AnimationPlayer")

var f1_grenade:Resource = preload("res://Scenes/Weapons/Grenades/F1_rig.tscn")
var ptr_grenade:RigidBody2D

var throw_vec:Vector2


func _ready():
	gv.set_cursor_green()
	#anim_player.connect("animation_finished",_on_animation_finished)
	#create_grenade()
	
func _on_animation_finished() -> void:
	#shoot()
	pass	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Fire"):
		shoot()
		

#func _exit_tree():
	#print(self.name + ": _exit_tree!")
	#grenade.queue_free()

func shoot():

	if ammo > 0:
		ammo -= 1
	else:
		return	

	var grenade:RigidBody2D = f1_grenade.instantiate()
	grenade.name = "Grenade-F1-" + str(ammo)
	grenade.transform = get_node("GrenadeSpawn").global_transform
	#grenade.scale = Vector2(0.5,0.5)
	get_tree().root.add_child(grenade)
	#grenade.connect('explode', _on_f1_explode)
	grenade.position = $GrenadeSpawn.global_position
	grenade.rotation = $GrenadeSpawn.global_rotation
	

	anim_player.play("throw_grenade")
	throw_vec = get_global_mouse_position() - global_position
	#print(str(tmp) + ": vec")
	throw_vec.x *= 0.5  
	#grenade.throw(Vector2(500,-1000))
	grenade.throw(throw_vec)

# func _on_f1_explode() -> void:
# 	await get_tree().create_timer(0.1).timeout
# 	create_grenade()
