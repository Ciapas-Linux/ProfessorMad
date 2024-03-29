
# #####################
# DUMMY gun Node.SCRIPT #
# #####################

extends Sprite2D
var ammo:int = 0
signal fire


# Disable all processing this dummy node!
func _ready() -> void:
	set_process_input(false)
	set_process_unhandled_input(false)
	set_process(false)
	
	


