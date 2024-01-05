# ######################
# # explosive2 .SCRIPT #
# ######################

extends Node2D


@onready var Coin:Area2D

func _ready():
	Coin = get_node("Coin")
	Coin.get_node("collision").set_deferred("disabled", true)
	Coin.visible = false
	
@warning_ignore("unused_parameter")	
func _process(delta):
	pass

func _on_box_2_explode():
	Coin.get_node("collision").set_deferred("disabled", false)
	Coin.visible = true
	Coin.get_node("coin_img").play("fadein")
	


 
