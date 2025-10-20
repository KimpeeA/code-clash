@tool
class_name FallState
extends EntityState

@export var _gravity := 980.0


func _on_enter(args) -> void:
	super(args)


func _on_update(delta: float) -> void:
	_agent.velocity.y += _gravity * delta
	_agent.move_and_slide()

	if _agent.is_on_floor():
		change_to_next()
		return
