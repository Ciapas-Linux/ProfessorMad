extends Label

func _process(_delta):
	text = "%s" % [gv.Player.Player_gold] + " złoty"
