# Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name P25DState
extends State

var player25Ds: Player25D

func _ready() -> void:
	await owner.ready
	player25Ds = owner as  Player25D
	assert(player25Ds != null)
