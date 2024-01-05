extends Label

func _process(_delta):
	#if(visible):
	if gv.Hero_direction == Vector2.RIGHT:
		text = "Dir: RIGHT" 
	if gv.Hero_direction == Vector2.LEFT:
		text = "Dir: LEFT" 			
	
