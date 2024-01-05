# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name P25StateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(p25state_name)
@export var p25initial_state := NodePath()
@onready var p25state: P25State = get_node(p25initial_state)


func _ready() -> void:
	await owner.ready
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.p25state_machine = self
	p25state.enter()


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	p25state.handle_input(event)


func _process(delta: float) -> void:
	p25state.update(delta)


func _physics_process(delta: float) -> void:
	p25state.physics_update(delta)


func transition_to(p25target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(p25target_state_name):
		return

	p25state.exit()
	p25state = get_node(p25target_state_name)
	p25state.enter(msg)
	emit_signal("transitioned", p25state.name)
