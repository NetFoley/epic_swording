extends Node
class_name EndlessSpawnManager

@export var exploder_container : NodePath
@export var shooter_container : NodePath

var targetted_spawner : int
var enemy_to_spawn_type : PackedScene #1 exploder #2 shooter
var enemyid : int
var randomizer : RandomNumberGenerator

func _ready() -> void:
	randomizer = RandomNumberGenerator.new()
	%SpawnTimer.timeout.connect(spawn_enemy)
	%SpawnTimer.start()
	GAME.PLAYER_NODE.set_camera_zoom(Vector2(1.0, 1.0))

func spawn_enemy() -> void:
	targetted_spawner = get_random_spawner_id()
	if is_instance_valid(get_child(targetted_spawner)):
		enemy_to_spawn_type = get_enemy_to_spawn_type()
		var enemy_to_spawn_object = enemy_to_spawn_type.instantiate()
		enemy_to_spawn_object.set_position(get_child(targetted_spawner).global_position)
		if enemyid == 1: get_node(exploder_container).add_child(enemy_to_spawn_object, true)
		else: get_node(shooter_container).add_child(enemy_to_spawn_object, true)
		%SpawnTimer.set_wait_time(%SpawnTimer.get_wait_time() * 0.98)
		print(%SpawnTimer.get_wait_time())

func get_random_spawner_id() -> int:
	randomizer.randomize()
	return randomizer.randi_range(0, get_child_count() - 1)

func get_enemy_to_spawn_type() -> PackedScene:
	randomizer.randomize()
	var enemy_id : int = randomizer.randi_range(1, 2)
	enemyid = enemy_id
	return load("res://Characters/Enemy/Exploder/exploder.tscn") if enemy_id == 1 else load("res://Characters/Enemy/Shooter/shooter.tscn")
