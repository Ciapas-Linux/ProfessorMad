extends Label


func _process(_delta):
	text = "mouse: X" + str(int(get_global_mouse_position().x)) + "  Y:" + str(int(get_global_mouse_position().y)) 
	