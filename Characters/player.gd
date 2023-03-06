extends CharacterBody2D
class_name Player

@export var life = 5
@export var movement_speed = 200
@export var min_attack_speed = 0.1
@export var max_attack_speed = 0.5

var nb_of_executed = 0
var execute_progress_needed = 0.5
var damage = 1
var decaying = true
var can_hit = false
var has_hit = false
@onready var exec_line = $CanvasGroup/ExecLine
var execute_target = null:
	set(value):
		execute_target = value
		if is_instance_valid(execute_target):
			exec_line.visible = true
			exec_line.set_point_position(1, exec_line.to_local(execute_target.position))
			if nb_of_executed < 3:
				$UI/CenterContainer/Label.visible = true
		else:
			$UI/CenterContainer/Label.visible = false
			exec_line.visible = false
			
var progress = 0.0:
	set(value):
		progress = value
		progress_changed.emit(value)
		
var can_attack = true
@onready var current_attack_speed = max_attack_speed
var state = "idle"
@onready var attack_speed_bar = get_node("UI/MarginContainer/Container/attack_speed_bar")

@onready var sword = get_node("CanvasGroup/Weapon/SwordSpr")
@onready var decay_timer = get_node("DecayTimer")
@onready var sword_area : Area2D = get_node("CanvasGroup/Weapon/Area2D")
@onready var exec_area : Area2D = $ExecArea

signal progress_changed(value)

func _ready():
	GAME.PLAYER_NODE = self
	sword.attack_finished.connect(_on_attack_finished)
	progress_changed.connect(func(val): attack_speed_bar.value = val)
	decay_timer.timeout.connect(func(): decaying = true)
	sword_area.body_entered.connect(_on_sword_body_entered)
	
func _on_attack_finished():
	if !has_hit:
		miss_hit()
	can_attack = true; can_hit = false; sword_area.monitoring = false;
	
func miss_hit():
	decaying = true
	progress = clamp(progress - 0.1, 0.0, 1.0)

func _process(_delta):
	if Input.is_action_pressed("attack") and can_attack:
		attack()
	look_at(get_global_mouse_position())
	velocity = movement_speed*Vector2(Input.get_action_strength("move_right")-Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	update_execute_target()
	
func update_execute_target():
	execute_target = null
	if execute_progress_needed > progress:
		return
	var bodies = exec_area.get_overlapping_bodies()
	for body in bodies:
		if is_better_target(body):
			execute_target = body
	var areas = exec_area.get_overlapping_areas()
	for area in areas:
		var body = area.owner
		if is_better_target(body):
			execute_target = body
			
func is_better_target(body):
	if body == self:
		return false
	if !body.has_node("Executable") or !body.get_node("Executable").enabled:
		return false
	if !is_instance_valid(execute_target) or get_global_mouse_position().distance_to(body.position) < get_global_mouse_position().distance_to(execute_target.position):
		return true 
		
func _input(event):
	if event.is_action_pressed("execute"):
		execute()
	
func execute():
	if can_execute():
		$Execute.play()
		add_progress(execute_target.get_node("Executable").progress)
		position = execute_target.position
		execute_target.die()
		nb_of_executed += 1
	else:
		if progress > execute_progress_needed:
			progress -= 0.2

func can_execute():
	if !is_instance_valid(execute_target):
		return false
	return true

func _physics_process(_delta):
	move_and_slide()
	if decaying:
		progress = clamp(lerp(progress, 0.0, 0.004)-0.001, 0.0, 1.0)

func player_hit(value):
	life -= value
	$Shaker.start()
	$Hit.play()

func attack():
	sword_area.monitoring = true
	can_hit = true
	can_attack = false
	current_attack_speed = lerp(max_attack_speed, min_attack_speed, progress)
	sword.attack(current_attack_speed)
	$CanvasGroup/Weapon/Slash.play()
	has_hit = false

func _on_sword_body_entered(body):
	if !can_hit:
		return
	if body.has_method("hit"):
		has_hit = true
		body.hit(damage)
		add_progress(0.05)
		can_hit = false

func add_progress(value):
	if progress < execute_progress_needed and progress + value > execute_progress_needed:
		$CanExecute.play()
	decaying = false
	decay_timer.start(current_attack_speed+0.1)
	progress = clamp(0.0, 1.0, progress + value)
	
