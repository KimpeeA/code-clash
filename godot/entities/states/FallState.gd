@tool
class_name FallState
extends EntityState


@export
var _gravity := 980.0


func _on_enter(args) -> void:
	super(args)


func _on_update(delta: float) -> void:
	if _agent.is_on_floor():
		_agent.velocity.y = 0.0
		change_state(&"Idle")
		return

	_agent.velocity.y += _gravity * delta
	_agent.move_and_slide()
