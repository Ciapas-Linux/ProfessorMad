extends Label

#var weapon:Sprite2D 
var timer :Timer

#var spawn_node_path:String = "../../Player/Body_parts/weapon_spawn"

func _ready() -> void:
	#weapon = get_node(spawn_node_path).get_child(0)
	timer = Timer.new()
	timer.wait_time = 0.3
	timer.one_shot = false
	timer.connect("timeout", _on_timer_timeout)
	add_child(timer)
	timer.start()

# func _process(_delta):
# 	if weapon:
# 		text = "%s" % weapon.ammo 
# 	pass

func _on_timer_timeout() -> void:
	# if weapon:
	# 	text = "%s" % gv.Player_weapon.ammo 
	# else:
	# 	weapon = get_node(spawn_node_path).get_child(0)	

	text = "%s" % gv.Player.Player_weapon.ammo 
