extends Label

func _process(_delta):
	text = "Tilt:   " + str(gv.Player.Player_tilt)
	