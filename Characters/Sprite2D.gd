extends Sprite2D

@export var attack_range = 14

var direction = Vector2.RIGHT
var hit_down = true
var tween1
var tween2

signal attack_finished()
	
func attack(current_attack_speed):
	if tween1:
		tween1.kill()
	tween1 = create_tween()
	if hit_down:
		tween1.tween_property(self, "position", Vector2(attack_range, 8), current_attack_speed/2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	else:
		tween1.tween_property(self, "position", Vector2(attack_range, -8), current_attack_speed/2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	if tween2:
		tween2.kill()
	tween2 = create_tween()
	if hit_down:
		tween1.tween_property(self, "position", Vector2(0, 10), current_attack_speed/2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	else:
		tween1.tween_property(self, "position", Vector2(0, -10), current_attack_speed/2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	
	if hit_down:
		tween2.tween_property(self, "rotation", deg_to_rad(210), current_attack_speed).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	else:
		tween2.tween_property(self, "rotation", deg_to_rad(-30), current_attack_speed).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween1.finished.connect(func(): attack_finished.emit())
	hit_down = !hit_down
	
