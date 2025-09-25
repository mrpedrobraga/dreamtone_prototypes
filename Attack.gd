extends Control

var indicator = preload('res://assets/ball.png')

enum AttackType {
	HORIZONTAL_SLIDER,
	VERTICAL_SLIDER,
	SHRINKING_CIRCLE
}
export(AttackType) var attack_mode

signal hit
signal miss

var time_offset = 0
var horizontal_offset = 0
var vertical_offset = 0

var hitting_window = false

func _begin():
	time_offset = 0

func _process(delta):
	time_offset += delta
	
	hitting_window = false
	
	#--- LINEAR ---#
	match attack_mode:
		AttackType.HORIZONTAL_SLIDER:
			horizontal_offset = 32 * cos(time_offset * 5)
			vertical_offset = 4 * sin(time_offset * 3) # This is just for fun
			
			if $Hitbox.get_rect().has_point(Vector2(horizontal_offset, vertical_offset)+rect_size/2):
				hitting_window = true
		AttackType.VERTICAL_SLIDER:
			vertical_offset = 24 * cos(time_offset * 5)
			horizontal_offset = 4 * sin(time_offset * 3) # This is just for fun
			
			if $Hitbox.get_rect().has_point(Vector2(horizontal_offset, vertical_offset)+rect_size/2):
				hitting_window = true
	
	update()
	
	_handle_attack()

func _handle_attack():
	if Input.is_action_just_pressed('OK'):
		if hitting_window:
			emit_signal('hit')
		else:
			emit_signal('miss')


func _draw() -> void:
	var center = rect_size/2
	
	match attack_mode:
		AttackType.HORIZONTAL_SLIDER:
			_draw_indicator(
				center +
				Vector2.RIGHT * horizontal_offset +
				Vector2.UP * vertical_offset
			)
		AttackType.VERTICAL_SLIDER:
			_draw_indicator(
				center +
				Vector2.RIGHT * horizontal_offset +
				Vector2.UP * vertical_offset
			)

func _draw_indicator(where: Vector2):
	var size = Vector2(16, 16)
	var color = Color.white
	if hitting_window:
		color = Color.yellow
	draw_texture_rect(indicator, Rect2(where - size / 2, size), false, color)
