extends Sprite2D

var rysiek:Rysiek

var shift_x:int = 20
var shift_y:int = 100

var timer:Timer
signal it_was_shown

func _ready():
	self.visible = false
	rysiek = get_parent()
	
	timer = Timer.new()
	add_child(timer)
	timer.set_one_shot(true)
	timer.set_wait_time(5)
	timer.connect("timeout",  _timer_timeout)
		

@warning_ignore("unused_parameter")
func _physics_process(delta):
	position.x = gv.Enemy_position.x - shift_x
	position.y = gv.Enemy_position.y - shift_y

func _timer_timeout():
	var tween:Tween = create_tween()
	tween.tween_property(self, "modulate", Color(255,255,255,0), 3)
	await get_tree().create_timer(3).timeout
	gv.Player.Player_is_paused = false
	self.visible = false
	# emit_signal("it_was_shown")
		
	
# Turn red over the span of one second
func turn_red():
	var tween2 = create_tween()
	tween2.tween_property(self, 'modulate', Color.RED, 1.0)	

func first_time_catch_profesor():
	$SayTextLabel.text = "Eeeee ty \ncwaniaczku!"
	self.visible = true
	var tween:Tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector2.ONE * 1, 0.5)
	tween.parallel().tween_property(self, "position", Vector2(position.x - shift_x,position.y - shift_y), 0.5)
	tween.connect('finished', _on_tween_finished)
	print("rysiek say: Hello profesor!")
	shift_y += 100
	shift_x += 20
	timer.start()

func _on_idle_first_hero_catch() -> void:
	first_time_catch_profesor()

func _on_follow_left_first_hero_catch() -> void:
	print("rysiek say: Hello profesor!")
	first_time_catch_profesor()
	
func _on_tween_finished():
	print("DUPASIWO!")
	
