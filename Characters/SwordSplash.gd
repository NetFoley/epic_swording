extends Line2D

@export_node_path("Node2D") var connected_node 

var old_pos = Vector2(0,0)

func _physics_process(_delta):
	var node = get_node(connected_node)
	if !node:
		return
	set_point_position(0, old_pos)
	old_pos = to_local(node.global_position)
	
	set_point_position(1, old_pos)
