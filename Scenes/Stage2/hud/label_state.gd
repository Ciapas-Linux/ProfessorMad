extends Label

func _process(_delta):
	text = "STATE:   " + gv.player25D_fsm.p25state.name
