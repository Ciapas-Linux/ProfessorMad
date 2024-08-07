extends State2

# State Machine scripts Credits:
# From: https://github.com/addmix/godot_utils

@onready var player = $"../../"

@warning_ignore("unused_parameter")
func _enter(from : StringName) -> void:
	player.movement_enabled = false

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	#if the player is on the floor, we know that they just landed on the ground.
	if player.is_on_floor():
		change_state("Landed")
