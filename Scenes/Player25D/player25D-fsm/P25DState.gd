# Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name P25DState
extends P25State

var player25d: Player25D

func _ready() -> void:
	await owner.ready
	player25d = owner as  Player25D
	assert(player25d != null)
