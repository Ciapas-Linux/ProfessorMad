extends Sprite2D

@onready var But_l_spawn_marker:Marker2D = get_node("../../Lydka_l/But_l_spawn")
# /root/Stage1/Player/leg_l/Lydka_l/But_l_spawn

func _ready():
	position = But_l_spawn_marker.position
	pass

func _process(_delta):
	
	rotation = gv.Player.get_floor_angle()

	#print("AAAAAAAAAAAAAAAAAAAAAAA: " + str(self.get_path()))
	#global_position.x = But_l_spawn_marker.global_position.x + 6
	#global_position.y = But_l_spawn_marker.global_position.y - 10
	#rotation_degrees = randf_range(100,100)

	# if gv.Hero_direction == Vector2.LEFT:
	# 	flip_h = true
	# else:
	# 	flip_h = false
	pass