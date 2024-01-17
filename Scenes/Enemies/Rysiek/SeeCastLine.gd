extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()
	pass

func _draw():
	if get_parent().player_collision_point != Vector2(0,0):
		draw_line(gv.Enemy_global_position,
		get_parent().player_collision_point, Color(255, 0, 0), 0.5, true)










# draw_line(get_parent().enemy_global_position,
# get_parent().player_collision_point, Color(255, 0, 0), 1, true)
# get_parent().player_collision_point
