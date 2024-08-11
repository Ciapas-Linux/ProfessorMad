extends Sprite2D

# ##########
# TT hand Gun .SCRIPT
# ##########


@onready var anim_player : AnimationPlayer = get_node("AnimationPlayer")

var can_fire:bool = true
var bullet:Resource = preload("res://Scenes/Weapons/ak_47/Bullet/Bullet.tscn")
var bullet_shell:Resource = preload("res://Scenes/Weapons/ak_47/Bullet/Bullet_shell.tscn")
var recoil:int = 60
var shoots:int = 0
const ammo_max:int = 15
var ammo:int = ammo_max
signal fire
signal fire_stop


func _ready():
	$FiringSprite.visible = false
	$ammo.text = str(ammo)	
	
		
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())

	# smooth rotation:
	#var angle = (get_global_mouse_position() - self.global_position).angle()
	#self.global_rotation = lerp_angle(self.global_rotation, angle, delta * 5)

	$RayCast2D.target_position = get_local_mouse_position()			

	if Input.is_action_just_pressed("Fire"):
		if anim_player.is_playing() == false:
				anim_player.play("shoot")
		shoot()

					
func shoot():
	if ammo > 0:
		ammo -= 1
	else:
		return
	$ammo.text = str(ammo)		
	var blt:Area2D = bullet.instantiate()
	var shell:RigidBody2D = bullet_shell.instantiate()
	blt.name = "Bullet" + str(shoots)
	# $BulletsSpawn.call_defered("add_child",blt)
	blt.transform = get_node("BulletsSpawn").global_transform
	shell.transform = get_node("Shells_spawn").global_transform
	get_tree().root.add_child(blt)
	get_tree().root.add_child(shell)
	shoots += 1
	$snd_fire1.play()
	$FiringSprite.visible = true
	$FiringSprite.play("fire")
		
	if gv.Player.has_method("on_gun_fire"):
		gv.Player.on_gun_fire()


func _on_firing_sprite_animation_finished() -> void:
	$FiringSprite.visible = false
		









