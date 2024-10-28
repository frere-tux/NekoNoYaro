extends CatMotionState

var jump_time: float = 0.0
var previous_state: String


func physics_update(_delta: float) -> void:
	if player_cat.velocity.y < 0.0:
		finished.emit(FALLING, {"GoTo":previous_state})
		return
	elif player_cat.is_on_wall() and not Input.is_action_pressed("Jump"):
		finished.emit(HIT)
		return
	
	if previous_state != IDLE:	
		player_cat.update_velocity_to_follow_path(player_cat.speed, _delta)
	
	if jump_time < player_cat.max_jump_time and (Input.is_action_pressed("Jump")) or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		player_cat.velocity.y += player_cat.continuous_jump_velocity * _delta
		jump_time+= _delta
	elif player_cat.velocity.y < 0.0:
		finished.emit(previous_state)


func enter(_previous_state_path: String, _data := {}) -> void:
	player_cat.animated_sprite.play("Jump")
	
	previous_state = _previous_state_path
	
	player_cat.velocity.y = player_cat.initial_jump_velocity
	jump_time = 0.0
