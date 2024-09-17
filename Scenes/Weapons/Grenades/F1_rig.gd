extends RigidBody2D

@onready var F1_spawn_point : Marker2D = gv.Player.get_node("weapon_spawn/f1_grenade")

var velocity = Vector2(350, 0)
const ammo_max:int = 15
var ammo:int = ammo_max
var strength:Vector2
var direction = false
signal explode


func _ready() -> void:
	self.freeze = true
	print(self.name + ": ready!")

func _process(_delta: float) -> void:
	if freeze == true:
		global_position = F1_spawn_point.global_position
		
func throw_grenade(imp_vector):
	self.freeze = false
	strength = imp_vector
	if direction:
		strength.x *= -1
	apply_impulse(Vector2.ZERO,strength)
	$Timer.start()

func _on_area_entered(area:Area2D) -> void:
	print(self.name + " hit: " + area.name)
	# if area.has_method("hit"):
	# 	area.hit()
	# queue_free()

func _on_body_entered(body:Node2D) -> void:
	print(self.name + " hit: " + body.name)
	# if body.has_method("hit"):
	# 	body.hit()
	# queue_free()		 

func _on_timer_timeout() -> void:
	explode_grenade()

func explode_grenade():
	emit_signal("explode")
	queue_free()
