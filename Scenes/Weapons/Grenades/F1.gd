extends Area2D

var velocity = Vector2(350, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.y += gravity * delta
	position += velocity * delta
	rotation = velocity.angle()


func _on_area_entered(area:Area2D) -> void:
	print("F1 grenade hit: " + area.name)
	if area.has_method("hit"):
		area.hit()
	queue_free()


func _on_body_entered(body:Node2D) -> void:
	print("F1 grenade hit: " + body.name)
	if body.has_method("hit"):
		body.hit()
	
	queue_free()		 
