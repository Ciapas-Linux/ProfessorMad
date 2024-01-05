extends StaticBody2D

signal hit_me

func hit():
	emit_signal("hit_me")
