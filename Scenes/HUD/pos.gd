extends Label

func _process(_delta):
	#if(visible):
	text = "x: %s" % [int(gv.Player.global_position.x)] + "  y: %s" % [int(gv.Player.global_position.y)]
	
