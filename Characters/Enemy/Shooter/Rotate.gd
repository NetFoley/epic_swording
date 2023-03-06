extends State


# Called when the node enters the scene tree for the first time.
func _enter():
	var tween = target.create_tween()
	tween.tween_property(target, "rotation", target.global_position.direction_to(owner.AI.target_node.global_position).angle(), 1.0).set_trans(Tween.TRANS_CUBIC)
