extends TextureProgressBar

var rysiek:Rysiek

func _ready():
	rysiek = get_parent()
	value = rysiek.health
	position.x = gv.Enemy_position.x - 20
	position.y = gv.Enemy_position.y - 200
	

@warning_ignore("unused_parameter")
func _physics_process(delta):
	value = rysiek.health
	position.x = gv.Enemy_position.x - 20
	position.y = gv.Enemy_position.y - 200
	

