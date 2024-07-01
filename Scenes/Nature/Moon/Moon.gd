extends Node2D

@onready var tween: Tween

func _ready() -> void:
	global_position.x = gv.Player.global_position.x
	global_position.y = -1000
		
func _tween():
	if gv.Player.global_position.x != global_position.x:
		tween = get_tree().create_tween()
		tween.connect("finished", on_tween_finished)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_parallel(true)
		tween.tween_property(self, "global_rotation", randf_range(-2.0,2.0), randf_range(10,15))
		tween.tween_property(self, "global_position", Vector2(gv.Player.global_position.x, global_position.y), randf_range(4,8))
		

func on_tween_finished():
	pass

func _on_timer_timeout() -> void:
	_tween()
	#$Timer.wait_time = (randf_range(3,10))
