extends Control


func _on_yes_button_pressed() -> void:
	get_tree().change_scene_to_file("res://godot/scenes/logs_menu.tscn")




func _on_no_button_pressed() -> void:
	get_tree().quit()
