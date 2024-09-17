extends RigidBody2D

@onready var F1_spawn_point : Marker2D = gv.Player.get_node("weapon_spawn/f1_grenade")

var velocity = Vector2(350, 0)
const ammo_max:int = 15
var ammo:int = ammo_max
var strength:Vector2
var direction = false
var stick:bool = true
signal explode


func _ready() -> void:
	self.freeze = true
	$explosion_spr.visible = false
	print(self.name + ": ready!!")
	#scale = Vector2(0.1,0.1)
	

func _process(_delta: float) -> void:
	if stick == true:
		global_position = F1_spawn_point.global_position
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	pass	
		
func throw(imp_vector):
	stick = false
	self.freeze = false
	#apply_torque_impulse(25)
	apply_impulse(imp_vector,Vector2.ZERO)
	$Timer.start()

func _on_area_entered(area:Area2D) -> void:
	print(self.name + " hit: " + area.name)
	# if area.has_method("hit"):
	# 	area.hit()


func _on_body_entered(body:Node2D) -> void:
	print(self.name + " hit: " + body.name)
	if body.has_method("F1_hit"):
		body.F1_hit()
		explode_grenade()	
	 

func _on_timer_timeout() -> void:
	explode_grenade()

func explode_grenade():
	stick = false
	set_deferred("freeze", true)
	$sprite_obj.visible = false
	$explosion_spr.visible = true
	$explosion_spr.play()
	$snd_explode.play()
		
func _on_explosion_spr_animation_finished() -> void:
	emit_signal("explode")
	print(self.name + ": explode")
	queue_free()
