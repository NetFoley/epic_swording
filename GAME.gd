extends Node

var PLAYER_NODE : Player = null
var start_time = 0.0
var current_map_name = ""

var scores_path = "user://scores.json"
var is_survival = true
var nb_of_kill = 0

var enemies = []

func _ready():
	$EndSlowMo.timeout.connect(_end_slowmo)

func slow_mo(speed, duration):
	Engine.time_scale = speed
	$EndSlowMo.start(speed*duration)

func add_enemy(enemy):
	enemies.append(enemy)
	enemy.died.connect(_on_enemy_died)

func _on_enemy_died(enemy):
	enemies.erase(enemy)
	nb_of_kill += 1
	if !is_survival:
		return
	if enemies.size() <= 0:
		save_score(current_map_name, get_current_time())
		if PLAYER_NODE:
			PLAYER_NODE.time_label.active = false
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://Scenes/Menu.tscn")

func _end_slowmo():
	var tween = create_tween()
	tween.tween_property(Engine, "time_scale", 1.0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
func play(name):
	for child in get_children():
		if !child is AudioStreamPlayer:
			continue
		child.stop()
		if child.name == name:
			child.play()

func start_timer():
	start_time = Time.get_ticks_msec()

func get_current_time():
	return (Time.get_ticks_msec() - start_time)*0.001

func save_score(map_name, time):
	var old_scores = load_file(scores_path)
	
#	var data_to_send = {map_name: time}
	if is_survival:
		if !old_scores.has(map_name) or old_scores[map_name] < time:
			old_scores[map_name] = time
	else:
		if !old_scores.has(map_name) or old_scores[map_name] > time:
			old_scores[map_name] = time

#	if old_scores != null:
#		for old in old_scores:
#			data_to_send.append(old)

	var json_string = JSON.stringify(old_scores)
	var file = FileAccess.open(scores_path, FileAccess.WRITE)
	file.store_string(json_string)

func load_file(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var content = JSON.new().parse_string(file.get_as_text())
		return content
	else:
		return {}

func get_time_of_map(map_name):
	var data = load_file(scores_path)
	if data.has(map_name):
		return data[map_name]
	return null
