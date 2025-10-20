@tool
class_name DashState
extends EntityState

@export var _default_distance := 50.0
@export var _default_duration := 0.25

var _dash_add := 0.0  # how much extra speed to apply
var _decel_along := 0.0  # decay rate of dash_add
var _previous_velocity := 0.0
var _dir := 0.0


func _on_enter(args) -> void:
	super(args)
	_agent.set_animation(&"dash")

	var distance = float(_args.get("distance", _default_distance))
	var duration = float(_args.get("duration", _default_duration))
	if duration <= 0.0:
		change_state(&"Persistent")
		return

	_previous_velocity = _agent.velocity.x
	_dir = _agent._facing_direction

	# calculate the dash “boost” so it covers the distance in duration
	_dash_add = (2.0 * distance) / duration

	# deceleration rate for dash_add to decay back to zero
	_decel_along = _dash_add / duration


func _on_update(delta: float) -> void:
	print("vel: {}, prev_vel: {}, face_dir: {}, dir: {}".format([_agent.velocity, _previous_velocity, _agent._facing_direction, _dir], "{}"))

	# total horizontal velocity = previous velocity + dash boost
	_agent.velocity.x = _previous_velocity + _dir * _dash_add

	# decay dash_add
	_dash_add -= _decel_along * delta

	_agent.move_and_slide()

	if _dash_add <= 0.0:
		_agent.velocity.x = _previous_velocity
		change_state(&"Persistent", {"resume": true})
		return
