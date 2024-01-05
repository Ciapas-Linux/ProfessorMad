extends CharacterBody2D

signal Bullet_hit_me

func _ready():
	$DroneSprite.play("default")
			

func _physics_process(_delta):
	pass
	
func _process(_delta: float) -> void:
	pass
	

func hit():
	emit_signal("Bullet_hit_me")
	#print("Flying drone: somebody hit me by bullet!") 
	
	


func _on_explosion_animation_finished() -> void:
	pass 
