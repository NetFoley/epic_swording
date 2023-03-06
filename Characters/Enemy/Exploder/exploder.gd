extends "res://Characters/Enemy/enemy.gd"

func explode():
	$CPUParticles2D2.emitting = true
	var bodies = $Hitbox.get_overlapping_bodies()
	$Explode.play()
	for body in bodies:
		if body is Player:
			body.player_hit(1)
