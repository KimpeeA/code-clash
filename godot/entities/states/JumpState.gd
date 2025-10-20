@tool
class_name JumpState
extends EntityState


func _on_enter(args) -> void:
	super(args)
	_agent.set_animation(&"jump")

	_agent.velocity.y = -_agent._stats.jump_force
	_agent.move_and_slide()


func _after_enter(args) -> void:
	change_state_with_next(&"Fall", next_state)
