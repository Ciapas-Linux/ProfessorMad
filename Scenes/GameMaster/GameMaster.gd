extends CanvasLayer

#class_name GameMaster




var sprite:AnimatedSprite2D
var Stage:Node2D
#enum States { START, IDLE, STAGE_1 }
const START:int = 1
const IDLE:int =  2 
const STAGE_1:int = 3  
var current_state : int = IDLE
#var timer:Timer


var text_start:String = "Profesorze Łysolku!"


func _ready():
	Stage = get_node("/root/Stage")
	
	#Stage1 = get_tree().get_root().Stage1
	print("GameMaster name: " + name)
	print("GameMaster path: " + str(self.get_path()))
	visible = false
	set_process_input(false)
	# pause()
	
	#start()
	
func _physics_process(_delta):
	match current_state:
		STAGE_1:
			_process_on_STAGE(_delta)
		IDLE:
			_process_on_IDLE(_delta)
		START:
			_process_on_START(_delta)	

func _process(_delta):
	pass
			
func master_show():
	visible = true

func master_hide():
	visible = false	

func _process_on_START(_delta):
	pass

func _process_on_STAGE(_delta):
	pass

func _process_on_IDLE(_delta):
	pass	

func start():
	visible = true
	$master_sprite.play("Head_left")
	$show_snd.play()
	current_state = START
	

# on any node
func pause():
	#get_tree().process_mode = PROCESS_MODE_DISABLED
	#$root/Stage1.process_mode = PROCESS_MODE_DISABLED
	Stage.process_mode = PROCESS_MODE_DISABLED
	#get_tree().paused = true
	
func unpause():
	#process_mode = PROCESS_MODE_INHERIT
	Stage.process_mode = PROCESS_MODE_INHERIT


# get_tree().paused = true
# $root/gmaster.play("Head_left")
# sprite = get_node("/root/gmaster/master_sprite")
# $master_sprite.play("Head_left")
# sprite.play("Head_left")
# timer.start()	
