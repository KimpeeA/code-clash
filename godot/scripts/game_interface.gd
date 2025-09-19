extends CanvasLayer

@onready var main_buttons: VBoxContainer = $Control/VBoxContainer/MainButtons
@onready var settings: Control = $Control/Settings
@onready var hover_sfx: AudioStreamPlayer = $hover_fx

@onready
var greetings_msg: Label = $Control/GreetingsMessage

func _ready() -> void:
	greetings_msg.text = Auth.email
	set_visible_main_buttons(true)


func set_visible_main_buttons(visibility: bool) -> void:
	main_buttons.visible = visibility
	settings.visible = not visibility


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/Arena.tscn")


func _on_custom_button_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/customization_menu.tscn")


func _on_progress_button_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/progress_menu.tscn")


func _on_lead_b_button_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/leaderboards_menu.tscn")


func _on_marketplace_button_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/marketplace_menu.tscn")


func _on_setting_button_pressed() -> void:
	set_visible_main_buttons(false)


func _on_button_entered() -> void:
	hover_sfx.play()


func _on_return_button_mouse_entered() -> void:
	hover_sfx.play()


func _on_return_button_pressed() -> void:
	_ready()


func _on_music_control_value_changed(value: float) -> void:
	pass # Replace with function body.
