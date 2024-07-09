extends Sprite2D


var timer:Timer
var say_text:String
var time_out:int = 0
var shift_x:float = 0
var shift_y:float = 0


func _ready() -> void:
	visible = false
	$ChatText.text = say_text
	
	modulate = Color(255,255,255,0)
	visible = true
		
	#shift_x = 0.0
	#shift_y = 200

	timer.start()
	$Fade.play("fade_in")
	$snd_say.play()

	print("Cloud say: Start!")
		

func _process(_delta: float) -> void:
	global_position.x = gv.EnemyRysiek.global_position.x
	global_position.y = gv.EnemyRysiek.global_position.y - shift_y
	

func Say(text: String,timeout:int,shiftx:int,shifty:int ):
	say_text = text
	shift_x = shiftx
	shift_y = shifty
	time_out = timeout
	timer = Timer.new()
	add_child(timer)
	timer.set_one_shot(true)
	timer.set_wait_time(time_out)
	timer.connect("timeout",  _timer_timeout)

func _timer_timeout():
	$Fade.play("fade_out")
		
func _on_fade_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		queue_free()
		print("Cloud say: Free")
	











#var fade:Tween

#var parent_node:Window

#print("Cloud say: parent: " + parent_node.name)

#func _on_fade_finished():
#	print("Cloud say: fade in finished")

#parent_node = get_parent()


#fade_in.tween_property(self, "modulate", Color(255,255,255,0), 3)
	#fade = create_tween()
	#fade.tween_property(self, "modulate", Color(255,255,255,255), 3)
	#fade.connect('finished', _on_fade_finished)
	#visible = true
	#fade_in.tween_property(self, "modulate", Color(1,1,1,1.0), 1)
	#fade_in.play()
	
	#self_modulate = Color(1,1,1,1)

#visible = true
	#fade.tween_property(self, "modulate", Color(1,1,1,1.0), 1)


#set_modulate(lerp(Color(1,1,1,1), Color(1,1,1,0), 1*delta))
	#self_modulate = Color(1,1,1,1.0*delta)
	

#fade_in.tween_property(self, "modulate", Color(255,255,255,0), 3)
	#fade_in.tween_property(self, "modulate", Color(255,255,255,0), 0.1)
	
