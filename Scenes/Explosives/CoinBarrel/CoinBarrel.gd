# ######################
# # CoinBarell.gd      #
# ######################

extends Node2D

@onready var Coin:Area2D

func _ready():
	Coin = get_node("Coin")
	Coin.visible = false
	Coin.get_node("collision").set_deferred("disabled", true)
	
@warning_ignore("unused_parameter")	
func _process(delta):
	pass

func _on_barell_1_explode() -> void:
	Coin.get_node("collision").set_deferred("disabled", false)
	Coin.visible = true
	Coin.get_node("coin_img").play("fadein")
	

