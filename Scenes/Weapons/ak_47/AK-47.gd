# ##########
# AK-47.SCRIPT
# ##########
extends Sprite2D

var can_fire:bool = true
var bullet:Resource = preload("res://Scenes/Weapons/ak_47/Bullet/Bullet.tscn")
var bullet_shell:Resource = preload("res://Scenes/Weapons/ak_47/Bullet/Bullet_shell.tscn")
var recoil:int = 60
var shoots:int = 0
const ammo_max:int = 150
var ammo:int = ammo_max
signal fire
signal fire_stop
var timer_next_shot : Timer


func _ready():
	$FiringSprite.visible = false
	# $Bullet_shell.emiting(false)
	timer_next_shot = Timer.new()
	timer_next_shot.wait_time = 0.1
	timer_next_shot.one_shot = true
	timer_next_shot.connect("timeout", _on_timer_next_shot_timeout)
	add_child(timer_next_shot)
	$ammo.text = str(ammo)	
	

func _on_timer_next_shot_timeout() -> void:
	if gv.fsm.state.name == "Idle":
		position.y = position.y + recoil
	else:
		position.y = position.y + recoil
		position.x = position.x - recoil
	$Timer.start(0.1)
	shoot()	
		
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())

	# smooth rotation:
	#var angle = (get_global_mouse_position() - self.global_position).angle()
	#self.global_rotation = lerp_angle(self.global_rotation, angle, delta * 5)

	$RayCast2D.target_position = get_local_mouse_position()			

	if Input.is_action_just_pressed("Fire"):
		if gv.fsm.state.name == "Idle":
			position.y = position.y + recoil
		else:
			position.y = position.y + recoil
			position.x = position.x - recoil
		$Timer.start(0.1)
		shoot()

	if Input.is_action_pressed("Fire"):
		if timer_next_shot.is_stopped() == true:
			timer_next_shot.start()

	if Input.is_action_just_released("Fire"):
		timer_next_shot.stop()
		fire_stop.emit()	
				
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
	fire.emit()
	# $Bullet_shell.restart()
	# $Bullet_shell.emiting(true)
	

	

func _on_timer_timeout():
	if gv.fsm.state.name == "Idle":
		position.y = position.y - recoil
	else:
		position.y = position.y - recoil	
		position.x = position.x + recoil  
	

func _on_firing_sprite_animation_finished() -> void:
	$FiringSprite.visible = false
		











#func _draw():
	#draw_line($BulletsSpawn.position, get_global_mouse_position(), Color(255, 255, 0), 1)

#mouse_pos = get_global_mouse_position()
#global_rotation = rad_to_deg(global_position.angle_to(get_global_mouse_position()))/2
#global_rotation = position.angle_to_point(get_global_mouse_position())
#print_debug(get_global_mouse_position())	


