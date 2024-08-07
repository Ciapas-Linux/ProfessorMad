# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name StateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(state_name)

@export var initial_state := NodePath()
@onready var state: State = get_node(initial_state)

var previous_state:String

func _ready() -> void:
	await owner.ready
	# The state machine assigns itself to the State objects' state_machine property.
	for child:Node in get_children():
		child.state_machine = self
		child.set_process_mode(Node.PROCESS_MODE_DISABLED)
	state.set_process_mode(Node.PROCESS_MODE_INHERIT)
	state.enter()


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)


func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return

	previous_state = str(state.name)
	state.set_process_mode(Node.PROCESS_MODE_DISABLED)
	
	state.exit()
	state = get_node(target_state_name)
	state.set_process_mode(Node.PROCESS_MODE_INHERIT)
	state.enter(msg)
	emit_signal("transitioned", state.name)
	
