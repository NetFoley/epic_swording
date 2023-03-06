extends State


# Called when the node enters the scene tree for the first time.
func _enter():
	if get_parent().target_node:
		get_parent().change_state_name("Chase")
