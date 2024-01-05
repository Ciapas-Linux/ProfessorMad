
# #################
# # COIN  .SCRIPT #
# #################

extends Area2D


var hit:bool = false
@export var amount:int = 0


func _ready():
	$coin_img.play("fadein")
	#$coin_img/Rotation.play("rotate")
	amount = randi_range(1,25)
	$amount.text = "%s" % [amount]
	
@warning_ignore("unused_parameter")	
func _process(delta):
	pass

func _on_area_entered(area):
	if area.name.left(6) == "Bullet":
		hit = true
		$collision.set_deferred("disabled", true)
		$snd_coin.play()
		$coin_img.play("vanish")
		
		

func _on_body_entered(body):
	if body.name == "Player":
		hit = true
		$snd_coin.play()
		$coin_img.play("vanish")
		
	
func _on_snd_coin_finished():
	#queue_free()
	pass
	
func _on_coin_img_animation_finished() -> void:
	if $coin_img.animation == "fadein":
		$coin_img.play("idle")
	if hit == true:
		gv.Hero_gold += amount
		print("Coin: Hero grab " + str(amount) + " gold coin")
		queue_free()
	

# TRASH:
########


#var tween:Tween 
#var col = Color(0.0, 1.0, 0.0)
#$coin_img.modulate.a = 0.9
#$coin_img.material.set_shader_parameter("white_progress", 1.0)
#queue_free()
#tween = create_tween()
#tween = get_tree().create_tween().bind_node($coin_img)
#tween.tween_property($coin_img,"modulate", Color(0.0, 1.0, 0.0), 1)
#tween.tween_property($coin_img, "position", Vector2(500, 0), 3).as_relative()
#tween.tween_property($coin_img, "rotation", PI, 1)



