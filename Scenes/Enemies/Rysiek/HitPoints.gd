extends Label

var enemy:Enemy

func _ready():
	enemy = get_parent()
	text = str(enemy.health)
		

@warning_ignore("unused_parameter")
func _process(delta):
	pass

func _physics_process(_delta):	
	text = str(enemy.health)
	position.x = gv.Enemy_position.x
	position.y = gv.Enemy_position.y - 170
	
