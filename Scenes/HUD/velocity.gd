extends Label

var velocity:Vector2

func _process(_delta):
	text = "velocity X: " + str(int(gv.Player.get_velocity().x)) + "  Y: " + str(int(gv.Player.get_velocity().y)) 
	
