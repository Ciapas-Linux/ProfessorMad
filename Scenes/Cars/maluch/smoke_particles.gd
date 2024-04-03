extends CPUParticles2D


const MOVE_RIGHT: int = 0
const MOVE_LEFT: int = 1
const STOP: int = 2
var current_state : int = MOVE_RIGHT

func _ready() -> void:
	#one_shot = true
	#emitting = true
	pass

func _physics_process(_delta) -> void:
	match current_state:
		STOP:
			_process_on_state_stop()
		MOVE_RIGHT:
			_process_on_state_move_right(_delta)
		MOVE_LEFT:
			_process_on_state_move_left(_delta)

func _process_on_state_stop() -> void:
		pass
	
func _process_on_state_move_right(delta: float) -> void:
		pass

func _process_on_state_move_left(delta: float) -> void:
		pass
			