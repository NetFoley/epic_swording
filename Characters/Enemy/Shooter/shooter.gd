extends "res://Characters/Enemy/enemy.gd"

@export_file("*.tscn") var bullet_path

func shoot():
	$Shoot.play()
	var bullet = load(bullet_path).instantiate()
	bullet.rotation = pixel_group.rotation
	bullet.position = position
	bullet.shooter = self
	get_tree().root.add_child(bullet)
