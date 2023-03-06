extends ProgressBar

func _process(_delta):
	if value > owner.execute_progress_needed:
		$AnimationPlayer.play("blink")
		$AnimationPlayer.speed_scale = value
		$Shaker.start()
	else:
		$AnimationPlayer.stop()
		$Shaker.stop()
