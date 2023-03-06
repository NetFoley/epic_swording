extends State


# Called when the node enters the scene tree for the first time.
func _enter():
	target.visible = true

func _exit():
	target.visible = false
