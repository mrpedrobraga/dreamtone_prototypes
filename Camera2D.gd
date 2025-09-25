extends Camera2D

var shake_timer = 0

func shake():
	shake_timer = 0.1

func _process(delta: float) -> void:
	if shake_timer > 0:
		shake_timer = max(0, shake_timer - delta)
		offset = 2 * Vector2(randf(), randf())
	else:
		offset = Vector2()
