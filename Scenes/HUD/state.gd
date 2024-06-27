extends Label

func _physic_process(_delta):
	text = "STATE:   " + gv.fsm.state.name
	
