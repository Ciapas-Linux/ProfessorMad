extends Label

func _process(_delta):
	text = "STATE:   " + gv.fsm.state.name
	
