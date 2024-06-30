extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)    


func _on_quit_pressed() -> void:
	$snd_scifi_bleep.play()
	

func _on_snd_scifi_bleep_finished() -> void:
	print("")
	print("Game EXIT by User")
	print("")
	get_tree().quit()
