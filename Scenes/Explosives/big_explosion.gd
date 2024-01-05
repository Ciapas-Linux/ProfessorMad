extends Node2D

@onready var tween: Tween
var timer_explosion2: Timer
signal finished
 
func _ready() -> void:
	$Sprite1.visible = false
	$Sprite2.visible = false
	$CPUParticles2D.visible = false
	timer_explosion2 = Timer.new()
	add_child(timer_explosion2)
	timer_explosion2.wait_time = 0.4
	timer_explosion2.connect("timeout",_on_timer_explosion2_timeout)
	timer_explosion2.one_shot = true


func _process(_delta: float) -> void:
	pass


func _on_timer_explosion2_timeout():
	$snd_explode2.play()
	$Sprite2.play("explode")
	$Sprite2.visible = true
	$CPUParticles2D.visible = true
	$CPUParticles2D.emitting = true	

func explode()-> void:
	$snd_explode1.play()
	$Sprite1.play("explode")
	$Sprite1.visible = true
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR) # or TRANS_LINEAR,TRANS_QUINT,TRANS_CUBIC,TRANS_BACK,TRANS_SINE
	#tween.set_parallel(true)
	#tween.tween_property($object_spr, "rotation", randf_range(-2.5, 2.5), 0.9)
	tween.tween_property($Sprite1, "global_position", Vector2(global_position.x, global_position.y - 165), 2)
	timer_explosion2.start()



func _on_sprite_1_animation_finished() -> void:
	emit_signal("finished")
	queue_free()
