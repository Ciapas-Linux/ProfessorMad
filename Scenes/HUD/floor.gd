extends Label


func _process(_delta):
	#if(visible):
	text = "Floor: " + str(gv.Player.is_on_floor())
	
