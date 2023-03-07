extends State


func _enter():
	target.visible = true
	var tween = create_tween()
	tween.tween_property(target, "scale", Vector2(1,1), timer*0.45).from(Vector2(0,0)).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(target, "scale", Vector2(1,1), timer*0.35).from(Vector2(0,0)).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(target, "scale", Vector2(1,1), timer*0.2).from(Vector2(0,0)).set_trans(Tween.TRANS_CUBIC)
	
func _exit():
	target.visible = false
