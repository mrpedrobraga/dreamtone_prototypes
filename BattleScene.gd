extends Control

var attack_no = 0
var attacknodes = ["AttackNathan", "AttackNeil", "AttackJenny", "AttackDarell"]

func _on_Attack_hit() -> void:
	$BAM.show()
	_freeze_frame()
	$Camera2D.shake()
	$Hit.play()
	_next()

func _next():
	get_node("Attacks/"+attacknodes[attack_no]).active = false
	attack_no = (attack_no + 1) % attacknodes.size()
	get_node("Attacks/"+attacknodes[attack_no]).active = true
	
func _freeze_frame():
	get_tree().paused = true
	$Timer.start()
	yield($Timer, "timeout")
	get_tree().paused = false

func _on_Attack_miss() -> void:
	_next()
