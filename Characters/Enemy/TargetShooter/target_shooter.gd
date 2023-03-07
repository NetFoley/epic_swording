extends "res://Characters/Enemy/Shooter/shooter.gd"

func shoot():
	$Shoot.play()
	var bullet = load(bullet_path).instantiate()
	bullet.target = AI.target_node
	bullet.rotation = pixel_group.rotation
	bullet.position = position
	bullet.shooter = self
	get_parent().add_child(bullet)
	return bullet
