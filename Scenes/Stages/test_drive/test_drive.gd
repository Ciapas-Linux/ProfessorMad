
# ##################
# # Stage 1.SCRIPT #
# ##################

extends Node2D


func _ready():
	randomize()
	#print(get_node("/root"))
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	#get_tree().paused = true

	$Camera2DPro.SetFollowNode($Player)

	# $Camera2DPro.SetFollowNode($Enemy)

	# await get_tree().create_timer(2.0).timeout

	# $Camera2DPro.Tween_to($Enemy.global_position,Vector2(-400,0))
	
	# $Camera2DPro.Tween_to($Player.global_position,Vector2(-400,0),Vector2(1.4,1.4),6,2)


#func _process(delta):
	#pass
	
func _on_quit_pressed() -> void:
	get_node("HUD/snd_scifi_bleep").play()
	

func _on_snd_scifi_bleep_finished() -> void:
	get_tree().quit()









		
	
# ShakeScreen.shake(10,1,"Random")	
	
	
# You can import the script using the following syntax:
#const Date = preload("res://assets/util/Date.gd")

# Then you can start creating it with Date.new() etc.
# Note: if you use class_name on top of Date.gd,
# you don't have to explicitely include it, 
# Date will be defined anywhere as if it was 
# imported by default.
# Note 2: if you used the class keyword
# that actually makes an inner class
# (which means you'll need to type Date.Date).
# Scripts are unnamed classes already by default
# (unless named with class_name).
	




