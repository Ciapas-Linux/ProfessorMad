extends Label


func _process(_delta):
	#if(visible):
	text = "Floor: " + str(gv.Hero_is_on_floor)
	
