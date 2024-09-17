extends RigidBody2D

@onready var F1_spawn_point : Marker2D = gv.Player.get_node("weapon_spawn/f1_grenade")

var velocity = Vector2(350, 0)
const ammo_max:int = 15
var ammo:int = ammo_max

signal explode


func _ready() -> void:
	self.freeze = true
	print(self.name + ": ready!")


func _process(_delta: float) -> void:
	if freeze == true:
		global_position = F1_spawn_point.global_position
	#velocity.y += gravity * delta
	#position += velocity * delta
	#rotation = velocity.angle()
	

func throw_grenade():
	pass

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
