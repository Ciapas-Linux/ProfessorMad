extends Label

func _process(_delta):
	#if(visible):
	if gv.Player.Player_direction == Vector2.RIGHT:
		text = "Dir: RIGHT" 
	if gv.Player.Player_direction == Vector2.LEFT:
		text = "Dir: LEFT" 			
	
