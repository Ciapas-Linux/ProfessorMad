extends State2

# State Machine scripts Credits:
# From: https://github.com/addmix/godot_utils

@onready var player = $"../../"


#in this state you are moving/walking. I use the variable movement_enabled to
#control when user movement controls are obeyed.

@warning_ignore("unused_parameter")
func _enter(from : StringName) -> void:
	player.movement_enabled = true

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	#when the player's velocity is greater than 0, and not on the floor, we can
	#be sure they are falling, so we switch to the falling state.
	if player.velocity.y > 0.0 and !player.is_on_floor():
		change_state("Falling")
	#if the player's input indicates a jump, and we are on the floor, we switch
	#to the jumping state.
	elif player.input.y < 0.0 and player.is_on_floor():
		change_state("Jumping")
	#if the player isn't doing anything else, and there is no input, we can go
	#back to the idle state.
	elif player.input.x == 0.0:
		change_state("Idle")
