extends Label


func _process(_delta):
	match gv.Player.Player_up_down:
		0:
			text = "Go: flat"
		1:
			text = "Go: up"
		2:
			text = "Go: down"
	
	
	