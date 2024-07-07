extends Label


func _ready():
	if is_instance_valid(gv.EnemyRysiek):
		text = str(gv.EnemyRysiek.Rysiek_health)
		

func _process(_delta):
	pass

func _physics_process(_delta):	
	text = str(gv.EnemyRysiek.Rysiek_health)
	position.x = gv.EnemyRysiek.position.x - 20
	position.y = gv.EnemyRysiek.position.y - 230
	
