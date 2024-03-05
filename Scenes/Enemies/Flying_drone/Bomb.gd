extends CharacterBody2D

@export var gravity:float = 200.0
var drone:CharacterBody2D
var explosion_anim:AnimatedSprite2D
var explosion_snd:AudioStreamPlayer2D
var snd_finish:bool = false
var hit_target:bool = false
var kill_by_bullet:bool = false
var bullets_hit:int = 0
var collider_name:String = ""
const bullets_hit_max = 3
# lift_off - wystartować :)
var dump_bomb:bool = false
var drone_on_position:bool = false
var collision:KinematicCollision2D

signal early_hit
signal drop_bomb


func _ready():
	drone = get_node("../Drone")
	explosion_anim = get_node("Explosion")
	explosion_snd = get_node("../snd_explosion")
	global_position.x = drone.global_position.x
	global_position.y = drone.global_position.y
	#top_level = false
	$AnimationPlayer.play("rotate")
	print("Flying drone bomb: ready ...") 
		

func _physics_process(delta):
	#velocity.x = 100
	
	#print(drone.global_position.x) 
	
	
	
	#var collision = move_and_collide(velocity.y * delta)
	
	#player_distance = global_position.distance_to(gv.Hero_global_position)
	#if hit_target == false:
	#move_and_slide()
	
	if hit_target == false and drone_on_position == true:	
		gravity = randf_range(50,80)
		velocity.y += gravity * delta
		collision = move_and_collide(velocity * delta)
		if collision:
			print("Bomb: I hit ", collision.get_collider().name)
			collider_name = collision.get_collider().name
			if collider_name == "Player" or collider_name == "GruntBody2D":
				explode()
				
	if hit_target == false and drone_on_position == false:
		global_position.x = drone.global_position.x - 5
		global_position.y = drone.global_position.y + 30			

		
#	if drone_on_position == true:
#		if is_on_floor():
#			if hit_target == false:
#				hit_target = true
#				$BombSprite.visible = false
#				explosion_anim.play("explode")
#				explosion_snd.play()
			
		

func _process(_delta: float) -> void:
	pass
	
func explode():
	hit_target = true
	#$BombCollision.disabled = true
	$BombCollision.set_deferred("disabled", true) 
	$BombSprite.visible = false
	explosion_anim.play("explode")
	explosion_snd.play()
	

func hit():
	bullets_hit += 1
	if bullets_hit == bullets_hit_max:
		$AnimationPlayer.stop(true)
		kill_by_bullet = true
		visible = false
		drone.visible = false
		explosion_anim.play("explode")
		explosion_snd.play()
		print("Flying drone bomb: somebody hit me by bullet!") 
		


func _on_explosion_animation_finished() -> void:
	#explosion_anim.stop()
	visible = false
	# hit_target = false
	global_position.x = drone.global_position.x
	global_position.y = drone.global_position.y
	explosion_anim.visible = false
	drone_on_position = false
	#$BombSprite.visible = true
	#$AnimationPlayer.play("rotate")
	if kill_by_bullet == true:
		emit_signal("early_hit")
	
	queue_free()
	

func _on_snd_explosion_finished() -> void:
	pass 

func _on_flying_drone_on_position() -> void:
	drone_on_position = true
	print("Drone on position: YES")
	await get_tree().create_timer(0.5).timeout
	emit_signal("drop_bomb")
	dump_bomb = true
	#global_position.x = drone.global_position.x - 5
	#global_position.y = drone.global_position.y + 30			
	#top_level = true
	$AnimationPlayer.stop(true)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Bomb range hit: " + body.name)
	if body.has_method("bomb_explode"):
		body.bomb_explode()	 
	
