extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()
	pass

func _draw():
	draw_line(gv.Enemy_global_position,
	gv.Hero_global_position, Color(255, 0, 0), 0.5, true)
	

# get_parent().player_collision_point
