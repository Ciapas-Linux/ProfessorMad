extends Label

func _physics_process(_delta):
	text = "STATE:   " + gv.Player3d.Player25d_fsm.state.name
	
