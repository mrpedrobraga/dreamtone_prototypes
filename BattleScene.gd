extends Control

var attack_no = -1
var attacknodes = ["AttackNathan", "AttackNeil", "AttackJenny", "AttackDarell"]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('ui_accept'):
		_spawn_all()

func _spawn_all():
	for attack_node_name in attacknodes:
		var attack_node = get_node("Attacks/"+attack_node_name)
		yield(get_tree().create_timer(0.2), "timeout")
		attack_node.start()

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

func _on_Attack_miss() -> void:
	pass
