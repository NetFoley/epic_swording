extends CharacterBody2D

@export var speed = 150.0
var shooter 

# Called when the node enters the scene tree for the first time.
func _ready():
	$Hitbox.body_entered.connect(_on_body_entered)
	$DeleteTimer.timeout.connect(func():die())
	shoot()
	
func shoot():
	velocity = Vector2(1.0, 0.0).rotated(rotation)*speed
	$DeleteTimer.start()
	
func _physics_process(_delta):
	move_and_slide()
	
func _on_body_entered(body):
	if body is Player:
		body.player_hit(1)
		die()
	if body != shooter:
		die()
	

func die():
	queue_free()
