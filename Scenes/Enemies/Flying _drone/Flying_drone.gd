extends CharacterBody2D


var mouse_enter:bool = false

signal Bullet_hit_me

func _ready():
	self.input_pickable = true
	self.connect("mouse_entered", _on_Area2D_mouse_entered)
	self.connect("mouse_exited", _on_Area2D_mouse_exited)
	$DroneSprite.play("default")
			

func _physics_process(_delta):
	pass
	
func _process(_delta: float) -> void:
	pass
	

func _on_Area2D_mouse_entered() -> void:
	mouse_enter = true
	if gv.Hero_current_weapon == gv.Hero_guns["rocket_4"]:
		gv.set_cursor_green()
		gv.mouse_enter_node = self
	#$object_spr.visible = false
	

func _on_Area2D_mouse_exited() -> void:
	mouse_enter = false
	if gv.Hero_current_weapon == gv.Hero_guns["rocket_4"]:
		gv.set_cursor_orange()
		gv.mouse_enter_node = null
	#$object_spr.visible = true


func hit():
	emit_signal("Bullet_hit_me")
	#print("Flying drone: somebody hit me by bullet!") 
	
	


func _on_explosion_animation_finished() -> void:
	pass 
