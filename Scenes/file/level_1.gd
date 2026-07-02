extends Control

var selected_character: String = ""

@onready var background = get_node_or_null("Background")
@onready var panel_node = get_node_or_null("Panel")

@onready var name_input = get_node_or_null("NameInput")
@onready var choose_label = get_node_or_null("ChooseCharacterLabel")
@onready var alert_label = get_node_or_null("AlertLable")

@onready var character_layer = get_node_or_null("CharacterLayer")
@onready var boy_image = get_node_or_null("CharacterLayer/BoyImage")
@onready var girl_image = get_node_or_null("CharacterLayer/GirlImage")
@onready var boy_button = get_node_or_null("CharacterLayer/BoyButton")
@onready var girl_button = get_node_or_null("CharacterLayer/GirlButton")

@onready var start_button = get_node_or_null("StartButton")
@onready var back_button = get_node_or_null("BackButton")
@onready var click_sound = get_node_or_null("ClickSound")


func _ready() -> void:
	setup_layers()
	setup_style()
	setup_character_buttons()
	connect_buttons()
	
	if alert_label != null:
		alert_label.text = ""


func setup_layers() -> void:
	if background != null:
		background.z_index = 0
	
	if panel_node != null:
		panel_node.z_index = 1
		panel_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	if name_input != null:
		name_input.z_index = 10
	
	if choose_label != null:
		choose_label.z_index = 10
	
	if alert_label != null:
		alert_label.z_index = 10
	
	if start_button != null:
		start_button.z_index = 10
	
	if character_layer != null:
		character_layer.z_index = 30
		character_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		character_layer.move_to_front()
	
	if boy_image != null:
		boy_image.z_index = 31
		boy_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
		boy_image.visible = true
	
	if girl_image != null:
		girl_image.z_index = 31
		girl_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
		girl_image.visible = true
	
	if boy_button != null:
		boy_button.z_index = 32
		boy_button.visible = true
	
	if girl_button != null:
		girl_button.z_index = 32
		girl_button.visible = true
	
	if back_button != null:
		back_button.z_index = 40
		back_button.visible = true
		back_button.move_to_front()


func setup_style() -> void:
	if choose_label != null:
		choose_label.text = "اختر الشخصية التي تود أن ترافقك في مغامراتك."
		choose_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		choose_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		choose_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		choose_label.add_theme_font_size_override("font_size", 18)
	
	if alert_label != null:
		alert_label.text = ""
		alert_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		alert_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		alert_label.add_theme_font_size_override("font_size", 18)
	
	if name_input != null:
		name_input.placeholder_text = "ماهو اسمك ؟"
		name_input.alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_input.add_theme_font_size_override("font_size", 20)
		
		var input_style := StyleBoxFlat.new()
		input_style.bg_color = Color(0.05, 0.08, 0.06, 0.85)
		input_style.border_color = Color(0.95, 0.85, 0.55, 1.0)
		input_style.set_border_width_all(3)
		input_style.set_corner_radius_all(10)
		
		name_input.add_theme_stylebox_override("normal", input_style)
		name_input.add_theme_stylebox_override("focus", input_style)
		name_input.add_theme_color_override("font_color", Color(1, 1, 1, 1))
		name_input.add_theme_color_override("font_placeholder_color", Color(1, 1, 1, 0.65))
	
	if start_button != null:
		start_button.text = "هيا نبدأ مغامراتنا!"


func setup_character_buttons() -> void:
	if boy_image != null:
		boy_image.visible = true
		boy_image.modulate = Color(1, 1, 1, 1)
		if boy_image is TextureRect:
			boy_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	if girl_image != null:
		girl_image.visible = true
		girl_image.modulate = Color(1, 1, 1, 1)
		if girl_image is TextureRect:
			girl_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	if boy_button != null:
		make_button_transparent(boy_button)
		boy_button.disabled = false
		boy_button.visible = true
	
	if girl_button != null:
		make_button_transparent(girl_button)
		girl_button.disabled = false
		girl_button.visible = true


func make_button_transparent(button: Button) -> void:
	button.text = ""
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var empty_style := StyleBoxEmpty.new()
	button.add_theme_stylebox_override("normal", empty_style)
	button.add_theme_stylebox_override("hover", empty_style)
	button.add_theme_stylebox_override("pressed", empty_style)
	button.add_theme_stylebox_override("focus", empty_style)
	button.add_theme_stylebox_override("disabled", empty_style)


func connect_buttons() -> void:
	if boy_button != null:
		if not boy_button.pressed.is_connected(_on_boy_pressed):
			boy_button.pressed.connect(_on_boy_pressed)
	
	if girl_button != null:
		if not girl_button.pressed.is_connected(_on_girl_pressed):
			girl_button.pressed.connect(_on_girl_pressed)
	
	if start_button != null:
		if not start_button.pressed.is_connected(_on_start_button_pressed):
			start_button.pressed.connect(_on_start_button_pressed)
	
	if back_button != null:
		if not back_button.pressed.is_connected(_on_back_button_pressed):
			back_button.pressed.connect(_on_back_button_pressed)
	
	if name_input != null:
		if not name_input.text_changed.is_connected(_on_name_input_text_changed):
			name_input.text_changed.connect(_on_name_input_text_changed)


func play_click() -> void:
	if click_sound != null:
		click_sound.stop()
		click_sound.play()


func _on_boy_pressed() -> void:
	play_click()
	selected_character = "boy"
	
	if boy_image != null:
		boy_image.modulate = Color(0.253, 0.931, 0.857, 1.0)
	
	if girl_image != null:
		girl_image.modulate = Color(1, 1, 1, 1)
	
	if alert_label != null:
		alert_label.text = ""
	
	print("تم اختيار شخصية سيف")


func _on_girl_pressed() -> void:
	play_click()
	selected_character = "girl"
	
	if girl_image != null:
		girl_image.modulate = Color(0.871, 0.649, 0.625, 1.0)
	
	if boy_image != null:
		boy_image.modulate = Color(1, 1, 1, 1)
	
	if alert_label != null:
		alert_label.text = ""
	
	print("تم اختيار شخصية لين")


func _on_name_input_text_changed(new_text: String) -> void:
	var player_name = new_text.strip_edges()
	
	if choose_label == null:
		return
	
	if player_name == "":
		choose_label.text = "اختر الشخصية التي تود أن ترافقك في مغامراتك."
	else:
		choose_label.text = "أهلاً " + player_name + "، اختر الشخصية التي تود أن ترافقك في مغامراتك."


func _on_start_button_pressed() -> void:
	play_click()
	
	if name_input == null or alert_label == null:
		return
	
	if name_input.text.strip_edges() == "":
		alert_label.text = "يجب كتابة الاسم أولاً!"
	elif selected_character == "":
		alert_label.text = "يرجى اختيار شخصية للمغامرة!"
	else:
		var tree = get_tree()
		await tree.create_timer(0.15).timeout
		tree.change_scene_to_file("res://Scenes/file/level_3.tscn")


func _on_back_button_pressed() -> void:
	play_click()
	
	var tree = get_tree()
	await tree.create_timer(0.15).timeout
	tree.change_scene_to_file("res://Scenes/file/main_menu.tscn")


func _on_button_pressed() -> void:
	_on_start_button_pressed()


func _on_texture_button_pressed() -> void:
	_on_back_button_pressed()
