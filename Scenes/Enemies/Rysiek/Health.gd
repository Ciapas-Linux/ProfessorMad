extends TextureProgressBar

var enemy:Enemy

func _ready():
	enemy = get_parent()
	value = enemy.health
	position.x = gv.Enemy_position.x - 20
	position.y = gv.Enemy_position.y - 200
	

@warning_ignore("unused_parameter")
func _physics_process(delta):
	value = enemy.health
	position.x = gv.Enemy_position.x - 20
	position.y = gv.Enemy_position.y - 200
	

