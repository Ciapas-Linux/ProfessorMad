extends TextureProgressBar

var Drone:CharacterBody2D

func _ready():
    Drone = get_parent()
    value = Drone.Drone_health
    position = gv.EnemyRysiek.global_position
	
func _physics_process(_delta):
    value = Drone.Drone_health
    position.x = Drone.position.x
    position.y = Drone.position.y - 100
