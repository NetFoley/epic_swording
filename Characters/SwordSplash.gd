extends Line2D

@export_node_path("Node2D") var connected_node 

var old_pos = Vector2(0,0)
var old_diff_pos = Vector2(0,0)
var i = 0

func _physics_process(_delta):
	var node = get_node(connected_node)
	if !node:
		return
	var diff_pos = old_diff_pos-(global_position)
	old_diff_pos = (global_position)
	
	set_point_position(0, to_local(old_pos))
	old_pos = (node.global_position)+diff_pos
	
	set_point_position(1, to_local(old_pos))
