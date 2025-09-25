extends Control

export var indicator_texture: Texture

# -- The different attack types...
#    in the game, only one of those will be implemented.

enum AttackType {
	HORIZONTAL_SLIDER,
	SHRINKING_CIRCLE
}
export(AttackType) var attack_mode

# -- the action associated with this target

export var active = false
export var action = "B"
export(float, 0.0, 1.0) var time_offset = 0.0
export(float, 0.0, 1.0) var angle_offset = 0.0

signal hit
signal miss

var time_since_beginning = 0 # time since start of this qte
var timer = 1       # timer for the qte to end
var timer_max = 1   # the value the timer gets reset to

# The position of the indicator on screen.
# Different attack types do different things with this.
var indicator_position: Vector2 

# When this is true, attacking will cause a hit!
# Otherwise, it *may* miss.
var hitting_window = false

func _ready() -> void:
	_begin()

# Resets the attack
func _begin():
	time_since_beginning = 0
	timer = timer_max
	
	if attack_mode == AttackType.SHRINKING_CIRCLE:
		indicator_position.x = (randf() - 0.5) * rect_size.x
		indicator_position.y = (randf() - 0.5) * rect_size.y

func _process(delta):
	time_since_beginning += delta
	
	if active:
		timer -= delta
		
		# You'll hit your attack if you do so when the indicator is inside the hitbox.
		_process_hitbox_check()
		
		if attack_mode == AttackType.SHRINKING_CIRCLE:
			# Auto attack when the shrinking circle reaches its target size.
			if timer < 0 or Input.is_action_just_pressed(action):
				_attack()
				_begin()
		# Otherwise, wait for input to attack.
		elif Input.is_action_just_pressed(action):
			_attack()
	
	#--- LINEAR ---#
	match attack_mode:
		AttackType.HORIZONTAL_SLIDER:
			var speed = 3
			indicator_position = Vector2(
				24 * cos(time_since_beginning * speed + time_offset * TAU),
				2 * sin(time_since_beginning * speed * 0.6)
			).rotated(angle_offset * TAU)
			indicator_position += rect_size / 2
		AttackType.SHRINKING_CIRCLE:
			var vector = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
			indicator_position += vector
	
	update()

func _process_hitbox_check():
	hitting_window = false
	for hitbox in get_tree().get_nodes_in_group("Hitbox"):
		hitting_window = hitting_window or hitbox.get_rect().has_point(indicator_position)

func _attack():
		if hitting_window:
			emit_signal('hit')
			return true
		else:
			emit_signal('miss')
			return false

func _draw() -> void:
	_draw_indicator(
		indicator_position
	)

func _draw_indicator(where: Vector2):
	var _indicator_size = Vector2(16, 16)
	var _indicator_color = Color.white
	
	if active:
		if hitting_window:
			_indicator_color = Color.red
	else:
		_indicator_color.a = 0.3
	
	draw_texture_rect(indicator_texture,  Rect2(where - _indicator_size / 2, _indicator_size), false, _indicator_color)
	
	if attack_mode == AttackType.SHRINKING_CIRCLE:
		var radius = 32 * (timer_max - (time_since_beginning - floor(time_since_beginning)))
		draw_arc(where, radius, 0, TAU, 64, Color.turquoise, 1.5)
