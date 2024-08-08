extends Label

func _process(_delta):
	text = "x: %.2f" % [gv.Player25d.global_position.x] + "  y: %.2f" % [gv.Player25d.global_position.y] + "  z: %.2f" % [gv.Player25d.global_position.z]
	
