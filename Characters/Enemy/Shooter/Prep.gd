extends State


# Called when the node enters the scene tree for the first time.
func _enter():
	var tween = create_tween()
	tween.tween_property(target, "scale:x", 1.0, 2.0).from(0.0)
	target.visible = true

func _exit():
	target.visible = false
