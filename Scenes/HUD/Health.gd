extends TextureProgressBar


func _ready():
	#print_debug("health ready ...") 
	#value = get_node("../../Player").health
	value = gv.Player.health


func _process(_delta):
	#print_debug(value)
	#value = get_node("../../Player").health 
	value = gv.Player.health
	pass

