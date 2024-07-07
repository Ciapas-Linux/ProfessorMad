extends TextureProgressBar


func _ready():
	if is_instance_valid(gv.EnemyRysiek):
		value = gv.EnemyRysiek.Rysiek_health
		position.x = gv.EnemyRysiek.position.x - 20
		position.y = gv.EnemyRysiek.position.y - 200

func _physics_process(_delta):
	value = gv.EnemyRysiek.Rysiek_health
	position.x = gv.EnemyRysiek.position.x - 20
	position.y = gv.EnemyRysiek.position.y - 200
	
