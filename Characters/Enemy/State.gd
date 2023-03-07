extends State

var target_node:
	set(value):
		if value == target_node:
			return
		target_node = value
		target_node_changed.emit(value)

signal target_node_changed(target)

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	target.new_visible_body.connect(_on_visible_body)
	target_node_changed.connect(_on_target_changed)

func _on_visible_body(body):
	if body is Player:
		target_node = body

func _on_target_changed(_target):
	change_state_node($Chase)
