extends Label

func _process(_delta):
	text = "Tilt:   " + str(gv.Player_tilt)
	