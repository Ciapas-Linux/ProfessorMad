extends TextureProgressBar

var enemy:Enemy

func _ready():
	enemy = get_parent()
	value = enemy.health
	position.x = gv.Enemy_position.x
	position.y = gv.Enemy_position.y - 140
	

@warning_ignore("unused_parameter")
func _physics_process(delta):
	value = enemy.health
	position.x = gv.Enemy_position.x
	position.y = gv.Enemy_position.y - 140
	

