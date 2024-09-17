extends Sprite2D

const ammo_max:int = 15
var ammo:int = ammo_max

var f1_grenade:Resource = preload("res://Scenes/Weapons/Grenades/F1_rig.tscn")
var grenade:RigidBody2D

func _ready():
	gv.set_cursor_green()
	create_grenade()
		

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("Fire"):
		shoot()

func _exit_tree():
	print(self.name + ": _exit_tree!")
	grenade.queue_free()

# func _notification(what):
# 	if (what == NOTIFICATION_PREDELETE):
# 		#grenade.queue_free()
# 		print(self.name + ": predelete!")


func shoot():
	if gv.mouse_enter_node == null:
		return
    	
	if ammo > 0:
		ammo -= 1
	else:
		return	

	grenade.throw_grenade()
	
	
func create_grenade():
	grenade = f1_grenade.instantiate()
	grenade.name = "Grenade-F1" 
	grenade.transform = get_node("GrenadeSpawn").global_transform
	get_tree().root.add_child(grenade)
	grenade.connect('explode', _on_f1_explode)
	grenade.position = $GrenadeSpawn.global_position
	grenade.rotation = $GrenadeSpawn.global_rotation
	grenade.scale = Vector2(0.5,0.5)

func _on_f1_explode() -> void:
	create_grenade()
