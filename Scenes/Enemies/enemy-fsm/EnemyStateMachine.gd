# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name EnemyStateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(estate_name)
@export var einitial_state := NodePath()
@onready var estate: EState = get_node(einitial_state)


func _ready() -> void:
	await owner.ready
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.estate_machine = self
	estate.enter()


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	estate.handle_input(event)


func _process(delta: float) -> void:
	estate.update(delta)


func _physics_process(delta: float) -> void:
	estate.physics_update(delta)


func transition_to(etarget_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(etarget_state_name):
		return

	estate.exit()
	estate = get_node(etarget_state_name)
	estate.enter(msg)
	emit_signal("transitioned", estate.name)
