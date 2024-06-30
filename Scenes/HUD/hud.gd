extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	$help.visible = false    


func _on_quit_pressed() -> void:
	$snd_quit.play()
	
func show_help():
	$snd_help.play()
	$help.visible = true
	$Show_help.visible = false	

func hide_help():
	$help.visible = false
	$Show_help.visible = true		

func _on_snd_scifi_bleep_finished() -> void:
	print("")
	print("Game EXIT by User")
	print("")
	get_tree().quit()
