extends Node
class_name State2

# State Machine scripts Credits:
# From: https://github.com/addmix/godot_utils


signal _change_state

func change_state(new_state : StringName) -> void:
	call_deferred("emit_signal", "_change_state", new_state)

#virtual 
func _ready() -> void:
	pass
#virtual
func _process(delta : float) -> void:
	pass
#virtual
func _physics_process(delta : float) -> void:
	pass
#virtual
func _unhandled_input(event : InputEvent) -> void:
	pass
#virtual
func _enter(from : StringName) -> void:
	pass
#virtual
func _exit(to : StringName) -> void:
	pass
