extends TextureRect

func show():
	modulate.a = 1

func _process(delta: float) -> void:
	if modulate.a > 0:
		modulate.a = max(0, modulate.a - delta * 4)
