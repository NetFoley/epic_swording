extends CharacterBody2D

@export var movement_speed = 80
@export var action_dist = 200
@export var vision_range = 200
@onready var enemy_anim : AnimationPlayer = get_node("EnemyAnim")

signal life_changed(value)
@onready var life_bar = $Control/Bars/LifeBar
@onready var stun_bar = $Control/Bars/StunBar
@onready var pixel_group = $PixelGroup
@onready var vision_area = $VisionArea
@onready var AI = $AI
var decaying_stun = true
var executable = false:
	set(value):
		executable = value
		$Executable.enabled = value
		if executable:
			$Control/Bars/Shaker.start()
		else:
			$Control/Bars/Shaker.stop()
			

signal new_visible_body(body)

@export var max_stun_value = 6
var stun_value : float = 0:
	set(value):
		stun_value = value
		stun_bar.value = value
		executable = stun_value >= max_stun_value
		
@export var life = 20:
	set(value):
		life = value
		life_changed.emit(value)
		if life <= 0:
			die()

func _ready():
	vision_area.get_child(0).shape.set_radius(vision_range)
	vision_area.body_entered.connect(_on_visible_body)
	life_changed.connect(life_bar._on_life_changed)
	life_bar.max_value = life
	life_bar.value = life
	stun_bar.max_value = max_stun_value
	stun_bar.value = 0
	$StunTime.timeout.connect(func():decaying_stun = true)
	
func _on_visible_body(body):
	new_visible_body.emit(body)

func _physics_process(_delta):
	if decaying_stun:
		stun_value = clamp(stun_value - 0.02, 0, max_stun_value)
	move_and_slide()
	

func hit(value):
	$Hit.play()
	decaying_stun = false
	$StunTime.start()
	stun_value += value
	life -= value
	enemy_anim.stop()
	enemy_anim.play("Hit")
	var particles = $CPUParticles2D.duplicate()
	particles.position = $CPUParticles2D.global_position
	get_tree().root.add_child(particles)
	particles.emitting = true

func die():
	var particles = $CPUParticles2D.duplicate()
	particles.position = $CPUParticles2D.global_position
	particles.amount = 20
	get_tree().root.add_child(particles)
	particles.emitting = true
	queue_free()
