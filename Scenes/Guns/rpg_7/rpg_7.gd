

# ############
# RPG_7.SCRIPT
# ############
extends Sprite2D

var can_fire:bool = true
var rpg_head:Resource = preload("res://Scenes/Guns/rpg_7/rpg_7_head.tscn")
var recoil:int = 130
var shoots:int = 0
const ammo_max:int = 15
var ammo:int = ammo_max
var ready_to_fire:bool = true
signal fire



func _ready():
	pass	

		
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	$RayCast2D.target_position = get_local_mouse_position()			

	if Input.is_action_just_pressed("Fire"):
		if gv.fsm.state.name == "target_up" or gv.fsm.state.name == "target_down":
			shoot()
			
			
func reload():
	if ready_to_fire == true:
		return
	$snd_reload.play()
	$war_head.visible = true
	ready_to_fire = true
				
func shoot():
	
	if ready_to_fire == false:
		return

	if ammo > 0:
		ammo -= 1
	else:
		return	
		
	var head:Area2D = rpg_head.instantiate()
	head.name = "rpg_7" + str(shoots)
	$war_head.visible = false
	head.transform = get_node("BulletsSpawn").global_transform
	get_tree().root.add_child(head)
	shoots += 1
	fire.emit()
	gv.Player.get_node("AnimationPlayer").play("rpg_shoot")
	ready_to_fire = false

	if gv.fsm.state.name == "Idle":
		position.y = position.y + recoil
	else:
		position.y = position.y + recoil
		position.x = position.x - recoil
		$Timer.start(0.5)
	

func _on_timer_timeout() -> void:
	if gv.fsm.state.name == "Idle":
		position.y = position.y - recoil
	else:
		position.y = position.y - recoil	
		position.x = position.x + recoil  

	gv.Player.get_node("AnimationPlayer").play("target_up_rpg")








#$FiringSprite.visible = false
	#scale = Vector2(2.0,2.0)




# $BulletsSpawn.call_defered("add_child",blt)

#$FiringSprite.visible = true
	#$FiringSprite.play("fire")



# $Bullet_shell.restart()
	# $Bullet_shell.emiting(true)

#func _draw():
	#draw_line($BulletsSpawn.position, get_global_mouse_position(), Color(255, 255, 0), 1)

#mouse_pos = get_global_mouse_position()
#global_rotation = rad_to_deg(global_position.angle_to(get_global_mouse_position()))/2
#global_rotation = position.angle_to_point(get_global_mouse_position())
#print_debug(get_global_mouse_position())	




