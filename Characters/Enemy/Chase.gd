extends State

func _update(_delta):
	var target_node = get_parent().target_node
	if !target_node:
		return
	owner.pixel_group.look_at(target_node.position)
	owner.velocity = owner.position.direction_to(target_node.position)*owner.movement_speed
	if owner.position.distance_to(target_node.position) < owner.action_dist:
		get_parent().change_state_name("Action")

func _exit():
	owner.velocity = Vector2(0,0)
	
