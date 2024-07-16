extends RigidBody2D



func _ready() -> void:
	pass



func _process(_delta: float) -> void:
	pass


func _on_body_entered(body:Node) -> void:
	print("Brick contact: body " + str(body.name))
