extends Label

func _process(_delta):
	text = "STATE:   " + gv.Player.Player_state
	#text = "STATE:   " + gv.Player.get_node("StateMachine").state.name
