class_name EntityStats
extends Resource


var move_duration: float = 0.2
var speed: float =  300
var running_speed: float =  speed * 2
var distance: int = 40

var dash_distance: float = 200
var dash_duration: float = 0.5


@export var jump_height : float = 80:
	get:
		return jump_height
	set(value):
		jump_height = value
		update_properties()
@export var jump_time_to_peak : float = 0.2:
	get:
		return jump_time_to_peak
	set(value):
		jump_time_to_peak = value
		update_properties()
@export var jump_time_to_descent: float = 0.2:
	get:
		return jump_time_to_descent
	set(value):
		jump_time_to_descent = value
		update_properties()


var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

func update_jump_properties(jump_height: float, jump_time_to_peak: float, jump_time_to_descent: float) -> void:
	jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
	jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak    * jump_time_to_peak   )) * -1.0
	fall_gravity = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0


func update_properties() -> void:
	update_jump_properties(jump_height, jump_time_to_peak, jump_time_to_descent)
