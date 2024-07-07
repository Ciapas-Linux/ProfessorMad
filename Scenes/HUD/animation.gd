extends Label


func _process(_delta):
	text = "Anim: " + gv.Player.anim_player.current_animation
	