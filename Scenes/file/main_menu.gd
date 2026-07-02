extends Control

@onready var click_sound = $ClickSound

func play_click():
	if click_sound:
		click_sound.play()


func _on_start_button_pressed() -> void:
	play_click()
	await get_tree().create_timer(0.15).timeout
	get_tree().change_scene_to_file("res://Scenes/file/level_1.tscn")


func _on_parent_button_pressed() -> void:
	play_click()
	await get_tree().create_timer(0.15).timeout
	get_tree().change_scene_to_file("res://Scenes/file/parents_painting.tscn")
