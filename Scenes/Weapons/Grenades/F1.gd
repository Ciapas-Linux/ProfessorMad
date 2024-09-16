extends Sprite2D

var velocity = Vector2(1350, 0)

const ammo_max:int = 15
var ammo:int = ammo_max

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(self.name + ": F1 grenade ready!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# velocity.y += 700 * delta
	# position += velocity * delta
	# rotation = velocity.angle()
	pass

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
