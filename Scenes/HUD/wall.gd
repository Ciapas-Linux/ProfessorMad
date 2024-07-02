extends Label


func _process(_delta):
	#if(visible):
	text = "Wall: " + str(gv.Player.is_on_wall())
	
