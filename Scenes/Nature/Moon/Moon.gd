extends Sprite2D


func _ready() -> void:
	position.x = gv.Hero_global_position.x
	global_position.y = -900
	
	


func _process(_delta: float) -> void:
	position.x = gv.Hero_global_position.x
	
