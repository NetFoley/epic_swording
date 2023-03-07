extends Label

var active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if active:
		if GAME.is_survival:
			text = var_to_str(GAME.nb_of_kill)
		else:
			text = var_to_str(GAME.get_current_time())
