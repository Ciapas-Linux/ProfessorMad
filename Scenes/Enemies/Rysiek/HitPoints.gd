extends Label

var rysiek:Rysiek

func _ready():
	rysiek = get_parent()
	text = str(rysiek.health)
		

@warning_ignore("unused_parameter")
func _process(delta):
	pass

func _physics_process(_delta):	
	text = str(rysiek.health)
	position.x = gv.Enemy_position.x - 20
	position.y = gv.Enemy_position.y - 230
	
