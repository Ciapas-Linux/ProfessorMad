# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name RysiekStateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(rstate_name)

@export var rinitial_state := NodePath()
@onready var rstate: RState = get_node(rinitial_state)

var previous_state:String

func _ready() -> void:
	await owner.ready
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.rstate_machine = self
	rstate.enter()


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	rstate.handle_input(event)


func _process(delta: float) -> void:
	rstate.update(delta)


func _physics_process(delta: float) -> void:
	rstate.physics_update(delta)


func transition_to(rtarget_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(rtarget_state_name):
		return

	previous_state = str(rstate.name)

	rstate.exit()
	rstate = get_node(rtarget_state_name)
	rstate.enter(msg)
	emit_signal("transitioned", rstate.name)
