@tool
class_name MoveState
extends EntityState

var _walk_speed := 140.0
var _run_speed := 220.0
var _speed := 0.0
var _dir := 0.0


func _on_enter(args) -> void:
	super(args)
	_agent.set_animation(&"walk")

	if _args.has("resume"):
		return

	_dir = Input.get_axis(&"left", &"right")
	if _dir == 0.0:
		_dir = signf(_agent._facing_direction)

	var run: bool = _args.get("run", false)
	if run:
		_speed = _run_speed
	else:
		_speed = _walk_speed

	_agent._facing_direction = _dir


func _on_update(delta: float) -> void:
	# check for direction switch
	var left := Input.is_action_pressed(&"left")
	var right := Input.is_action_pressed(&"right")

	# if both pressed or none pressed → stop
	if (not left and not right) or (left and right):
		_agent.velocity.x = move_toward(_agent.velocity.x, 0.0, _speed * 0.2)
		if is_equal_approx(_agent.velocity.x, 0.0):
			change_state(&"Idle")
		_agent.move_and_slide()
		return

	# detect direction switch
	var new_dir := int(right) - int(left)
	if new_dir != _dir:
		# slow down first before switching
		_agent.velocity.x = move_toward(_agent.velocity.x, 0.0, _speed * 0.4)
		if is_equal_approx(_agent.velocity.x, 0.0):
			change_state_with_next(&"Idle")
		_agent.move_and_slide()
		return

	_agent.velocity.x = move_toward(_agent.velocity.x, _dir * _speed, _speed * 0.5)
	_agent._facing_direction = _dir
	_agent.move_and_slide()

	# normal move
	if Input.is_action_pressed(&"dash"):
		change_state_with_next(&"Dash")
		return
	if Input.is_action_pressed(&"jump"):
		change_state_with_next(&"Jump")
		return
