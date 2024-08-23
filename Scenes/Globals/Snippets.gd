extends Node



# get top level node:
	# get_viewport().physics_object_picking_sort = true
	# get_viewport().physics_object_picking_first_only = true



# Adding new animations:
	# Export a new .glb and in Godot import tab select your new animation
	# check save to file and save the animation somewhere.
	# Then in your characterscene select your AnimationPlayer, go
	# to Animation->Manage Animation And select Load (in the same library)
	# and select the saved Animation. Et voilà 
