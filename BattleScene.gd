extends Control

func _on_Attack_hit() -> void:
	$BAM.show()
	_freeze_frame()
	$Camera2D.shake()
	$Hit.play()

func _freeze_frame():
	get_tree().paused = true
	$Timer.start()
	yield($Timer, "timeout")
	get_tree().paused = false
