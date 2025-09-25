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
var timer = 1
var timer_max = 1
var horizontal_offset = 0
var vertical_offset = 0

var hitting_window = false

func _ready() -> void:
	_begin()

func _begin():
	time_offset = 0
	timer = timer_max
	
	if attack_mode == AttackType.SHRINKING_CIRCLE:
		horizontal_offset = (randf() - 0.5) * rect_size.x
		vertical_offset = (randf() - 0.5) * rect_size.y

func _process(delta):
	time_offset += delta
	timer -= delta
	
	if timer < 0:
		if attack_mode == AttackType.SHRINKING_CIRCLE:
			_attack()
		_begin()
	elif Input.is_action_just_pressed('OK'):
		if _attack():
			if attack_mode == AttackType.SHRINKING_CIRCLE:
				_begin()
	
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
		AttackType.SHRINKING_CIRCLE:
			var vector = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
			horizontal_offset += vector.x
			vertical_offset += vector.y
			
			if $Hitbox.get_rect().has_point(Vector2(horizontal_offset, vertical_offset)+rect_size/2):
				hitting_window = true
	
	update()

func _attack():
		if hitting_window:
			emit_signal('hit')
			return true
		else:
			emit_signal('miss')
			return false


func _draw() -> void:
	var center = rect_size/2
	
	var indicator_position = center +\
		Vector2.RIGHT * horizontal_offset +\
		Vector2.DOWN * vertical_offset
	
	_draw_indicator(
		indicator_position
	)
	
	if attack_mode == AttackType.SHRINKING_CIRCLE:
		var radius = 32 * (timer_max - (time_offset - floor(time_offset)))
		draw_arc(indicator_position, radius, 0, TAU, 64, Color.turquoise, 1.5)

func _draw_indicator(where: Vector2):
	var size = Vector2(16, 16)
	var color = Color.white
	if hitting_window:
		color = Color.yellow
	draw_texture_rect(indicator, Rect2(where - size / 2, size), false, color)
