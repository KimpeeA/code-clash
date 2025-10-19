@tool
class_name WalkState
extends EntityState


var _default_speed := 140.0
var _speed := 0.0


func _on_enter(args) -> void:
	super(args)

	_speed = _args.get("speed", _default_speed)


func _on_update(delta: float) -> void:
	var direction: float = Input.get_axis(&"left", &"right")

	if direction:
		_agent._facing_direction = direction

		_agent.velocity.x = move_toward(_agent.velocity.x, direction * _speed, _speed * 0.5)

		if Input.is_action_just_pressed(&"dash"):
			var dash_state := get_state(&"Dash")
			dash_state.next_state = self.get_path()
			change_state_node(dash_state)
			return
	else:
		_agent.velocity.x = move_toward(_agent.velocity.x, 0, _speed * 0.2)
		if is_equal_approx(_agent.velocity.x, 0.0):
			change_state(&"Idle")

	_agent.move_and_slide()
