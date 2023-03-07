extends HBoxContainer

@export_file("*.tscn") var scene_goal : String
@export var button_text = ""
@export var survival = false

func _ready():
	$Button.text = button_text
	$Button.pressed.connect(_pressed)
	var map_name = scene_goal.get_file()
	var time = GAME.get_time_of_map(map_name)
	if time:
		$Label.text = var_to_str(time)
	else:
		$Label.visible = false
		$VSeparator.visible = false

func _pressed():
	if scene_goal == "":
		return
	var map_name = scene_goal.get_file()
	GAME.current_map_name = map_name
	GAME.is_survival = survival
	get_tree().change_scene_to_file(scene_goal)
	
