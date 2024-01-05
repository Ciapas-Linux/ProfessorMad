# #####################
# # Mouse     .SCRIPT #
# #####################

extends Sprite2D


func _ready():
	pass


@warning_ignore("unused_parameter")
func _process(delta):
	position = get_global_mouse_position()
	position.x -= 5
	position.y -= 5  
	
