extends Label

func _process(_delta):
	text = "STATE:   " + str(gv.fsm.state.name)
	#text = "STATE:   " + gv.Player.get_node("StateMachine").state.name
