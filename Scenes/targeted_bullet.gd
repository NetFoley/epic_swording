extends "res://Scenes/Bullet.gd"

var target

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	move_and_slide()
	if target:
		velocity = velocity.rotated(lerp(0.0, velocity.angle_to(global_position.direction_to(target.global_position)), 2.0*delta))
		rotation = velocity.angle()
		velocity = velocity.limit_length(speed)

func shoot():
	super.shoot()
	create_tween().tween_property(self, "speed", 0, 10.0)
