
# WOOD RAMP TEST OBJECT

extends StaticBody2D

var mouse_enter:bool = false


func _ready() -> void:
	self.input_pickable = true
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)


func _process(_delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	mouse_enter = true
	if gv.Player_current_weapon == 3:
		gv.set_cursor_green()


func _on_mouse_exited() -> void:
	mouse_enter = false
	if gv.Player_current_weapon == 3:
		gv.set_cursor_orange()
	
func hit():
		print("wood ramp: dostałam czymś")
		$Bullet_holes.hit()
	

		

