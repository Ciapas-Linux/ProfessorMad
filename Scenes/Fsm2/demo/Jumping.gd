extends State2

# State Machine scripts Credits:
# From: https://github.com/addmix/godot_utils

@onready var player = $"../../"

@warning_ignore("unused_parameter")
func _enter(from : StringName) -> void:
	#we allow the player to change their movement while jumping, in case they change their mind.
	player.movement_enabled = true
	player.jump()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	#when the player's velocity is greater than 0, and not on the floor, we can
	#be sure they are falling, so we switch to the falling state.
	if player.velocity.y > 0.0 and !player.is_on_floor():
		change_state("Falling")
