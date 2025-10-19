class_name Entities
extends Node

@onready var camera: PhantomCamera2D = $PhantomCamera


func _ready() -> void:
	for e: Entity in find_children("*", "Entity"):
		camera.append_follow_targets(e)
