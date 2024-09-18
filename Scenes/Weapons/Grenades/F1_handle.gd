extends Sprite2D

@onready var anim_player : AnimationPlayer = gv.Player.get_node("AnimationPlayer")
var f1_grenade:Resource = preload("res://Scenes/Weapons/Grenades/F1_rig.tscn")
var throw_vec:Vector2

const ammo_max:int = 15
var ammo:int = ammo_max
var can_shoot:bool = true

func _ready():
	gv.set_cursor_green()
	anim_player.connect("animation_finished",_on_animation_finished)
	
func _on_animation_finished(anim_name:StringName) -> void:
	if anim_name == "throw_grenade":
		visible = false
		$Timer.start()
		can_shoot = false
		shoot()
		

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Fire"):
		if can_shoot ==  true:
			anim_player.play("throw_grenade")
		
func shoot():
	if ammo > 0:
		ammo -= 1
	else:
		return	

	var grenade:RigidBody2D = f1_grenade.instantiate()
	grenade.name = "Grenade-F1-" + str(ammo)
	grenade.transform = get_node("GrenadeSpawn").global_transform
	get_tree().root.add_child(grenade)
	grenade.position = $GrenadeSpawn.global_position
	grenade.rotation = $GrenadeSpawn.global_rotation
	#anim_player.play("throw_grenade")
	throw_vec = get_global_mouse_position() - global_position
	#print(str(tmp) + ": vec")
	throw_vec.x *= 0.5  
	grenade.throw(throw_vec)


# 	await get_tree().create_timer(0.1).timeout



func _on_timer_timeout() -> void:
	visible = true
	can_shoot = true
