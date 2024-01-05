extends Label

var weapon:Sprite2D 
var timer :Timer

func _ready() -> void:
	weapon = get_node("../../Player/Torso/arm_r").get_child(1)
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
	if weapon:
		text = "%s" % weapon.ammo 
	else:
		weapon = get_node("../../Player/Torso/arm_r").get_child(1)	