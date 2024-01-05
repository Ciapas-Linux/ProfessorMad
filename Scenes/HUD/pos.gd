extends Label

func _process(_delta):
	#if(visible):
	text = "x: %s" % [int(gv.Hero_global_position.x)] + "  y: %s" % [int(gv.Hero_global_position.y)]
	
