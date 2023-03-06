extends Sprite2D

@export var attack_range = 14

var direction = Vector2.RIGHT
var hit_down = true

signal attack_finished()
	
func attack(current_attack_speed):
	var tween = create_tween()
	if hit_down:
		tween.tween_property(self, "position", Vector2(attack_range, 8), current_attack_speed/2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	else:
		tween.tween_property(self, "position", Vector2(attack_range, -8), current_attack_speed/2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

	var tween2 = create_tween()
	if hit_down:
		tween.tween_property(self, "position", Vector2(0, 10), current_attack_speed/2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	else:
		tween.tween_property(self, "position", Vector2(0, -10), current_attack_speed/2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	
	if hit_down:
		tween2.tween_property(self, "rotation", deg_to_rad(210), current_attack_speed).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	else:
		tween2.tween_property(self, "rotation", deg_to_rad(-30), current_attack_speed).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.finished.connect(func(): attack_finished.emit())
	hit_down = !hit_down
	
