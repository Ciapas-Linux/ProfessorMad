extends Label


func _process(_delta):
	#if(visible):
	text = "Wall: " + str(gv.Hero_is_on_wall)
	