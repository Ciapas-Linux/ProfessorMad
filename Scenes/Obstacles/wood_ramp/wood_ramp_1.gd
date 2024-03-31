extends StaticBody2D

var mouse_enter:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.input_pickable = true
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	mouse_enter = true
	if gv.Hero_current_weapon == gv.Hero_guns["rocket_4"]:
		gv.set_cursor_green()


func _on_mouse_exited() -> void:
	mouse_enter = false
	if gv.Hero_current_weapon == gv.Hero_guns["rocket_4"]:
		gv.set_cursor_orange()
	#$object_spr.visible = true	

func hit():
		print("wood ramp: dostałam")
		$Bullet_holes.hit()
	

		

