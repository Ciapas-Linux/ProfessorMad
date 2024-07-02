extends Label

func _process(_delta):
	text = "%s" % [gv.Player_gold] + " złoty"
