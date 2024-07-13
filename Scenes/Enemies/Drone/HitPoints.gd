extends Label

var Drone:CharacterBody2D

func _ready():
	Drone = get_parent()
	text = str(Drone.Drone_health)
	#position.x = Drone.position.x
	#position.y = Drone.position.y - 130
	position = gv.EnemyRysiek.global_position
		

@warning_ignore("unused_parameter")
func _process(delta):
	pass

func _physics_process(_delta):	
	text = str(Drone.Drone_health)
	position.x = Drone.position.x
	position.y = Drone.position.y - 130
