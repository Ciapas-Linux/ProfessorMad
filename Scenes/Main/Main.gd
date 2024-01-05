
extends Node2D


func _ready() -> void:
	
	get_tree().change_scene_to_file("res://Scenes/Stages/Stage1.tscn")	



func _process(_delta: float) -> void:
	pass






# Mr.NOTEPAD:

# gv.goto_scene("res://Scenes/Stages/Stage1.tscn")
# var Stage1 = preload("res://Scenes/Stages/Stage1.tscn").instantiate()
