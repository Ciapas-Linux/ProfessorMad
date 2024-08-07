extends Node
class_name StateMachine2


# State Machine scripts Credits:
# From: https://github.com/addmix/godot_utils

var states :Dictionary = {}

@export var current_state : String = "":
	set(x):
		current_state = x

var state : State2

# is : , or is of a given built-in type.
# !x = not x  
func _ready() -> void:
	var children : Array[Node] = get_children()
	for x:Node in children:
		var child : State2
		if !x is State2: # if Node x not extend State2 then continue ...
			continue
		child = x
		states[child.name] = child
		child._change_state.connect(change_state)
		child.set_process_mode(Node.PROCESS_MODE_DISABLED)

	states[current_state].set_process_mode(Node.PROCESS_MODE_INHERIT)
	states[current_state]._enter("_init")

func change_state(new_state : StringName) -> void:
	#exit current state, and disable the code from running
	states[current_state]._exit(new_state)
	states[current_state].set_process_mode(Node.PROCESS_MODE_DISABLED)

	#enter new state, and make the new state run
	states[new_state]._enter(current_state)
	current_state = new_state
	states[current_state].set_process_mode(Node.PROCESS_MODE_INHERIT)
