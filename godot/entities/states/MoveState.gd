@tool
class_name MoveState
extends EntityState

var _walk_speed := 140.0
var _run_speed := 140.0
var _speed := 0.0


func _on_enter(args) -> void:
	super(args)

	var run: bool = _args.get("run", false)
	if run:
		_speed = _run_speed
	else:
		_speed = _walk_speed


func _on_update(delta: float) -> void:
	var direction: float = Input.get_axis(&"left", &"right")

	if direction:
		if Input.is_action_pressed(&"dash"):
			change_state_with_next(&"Dash")
			return
		if Input.is_action_pressed(&"jump"):
			change_state_with_next(&"Jump")
			return

		_agent._facing_direction = direction

		_agent.velocity.x = move_toward(_agent.velocity.x, direction * _speed, _speed * 0.5)
	else:
		_agent.velocity.x = move_toward(_agent.velocity.x, 0, _speed * 0.2)

		if is_equal_approx(_agent.velocity.x, 0.0):
			change_state(&"Idle")

	_agent.move_and_slide()
