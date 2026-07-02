extends Control

@onready var password_input = get_node_or_null("LoginPanel/PasswordInput")
@onready var login_button = get_node_or_null("LoginPanel/LoginButton")
@onready var login_panel = get_node_or_null("LoginPanel")
@onready var back_button = get_node_or_null("TextureButton")
@onready var click_sound = get_node_or_null("ClickSound")

var alert_label: Label
var correct_password: String = "1234"


func _ready() -> void:
	create_alert_label()
	
	if password_input != null:
		password_input.secret = true
		password_input.placeholder_text = "أدخلي كلمة المرور"
		
		if not password_input.text_submitted.is_connected(_on_password_submitted):
			password_input.text_submitted.connect(_on_password_submitted)
	
	if login_button != null:
		if not login_button.pressed.is_connected(_on_login_button_pressed):
			login_button.pressed.connect(_on_login_button_pressed)
	
	if back_button != null:
		if not back_button.pressed.is_connected(_on_texture_button_pressed):
			back_button.pressed.connect(_on_texture_button_pressed)


func create_alert_label() -> void:
	alert_label = get_node_or_null("LoginPanel/AlertLabel")
	
	if alert_label == null and login_panel != null:
		alert_label = Label.new()
		alert_label.name = "AlertLabel"
		login_panel.add_child(alert_label)
	
	if alert_label != null:
		alert_label.visible = true
		alert_label.text = ""
		alert_label.z_index = 50
		alert_label.position = Vector2(40, 200)
		alert_label.size = Vector2(420, 40)
		alert_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		alert_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		alert_label.add_theme_font_size_override("font_size", 20)
		alert_label.add_theme_color_override("font_color", Color("#FFB3B3"))


func play_click() -> void:
	if click_sound != null:
		click_sound.stop()
		click_sound.play()


func _on_login_button_pressed() -> void:
	play_click()
	check_password()


func _on_password_submitted(new_text: String) -> void:
	play_click()
	check_password()


func check_password() -> void:
	if password_input == null:
		print("PasswordInput غير مربوط أو اسمه غلط")
		return
	
	var entered_password = password_input.text.strip_edges()
	
	if entered_password == correct_password:
		if alert_label != null:
			alert_label.add_theme_color_override("font_color", Color("#B8FFB8"))
			alert_label.text = "تم تسجيل الدخول بنجاح"
		
		await get_tree().create_timer(0.3).timeout
		
	
		get_tree().change_scene_to_file("res://Scenes/file/parent_dashboard.tscn")
	else:
		if alert_label != null:
			alert_label.visible = true
			alert_label.add_theme_color_override("font_color", Color("#FFB3B3"))
			alert_label.text = "كلمة المرور غير صحيحة"
			alert_label.move_to_front()
		
		password_input.text = ""


func _on_texture_button_pressed() -> void:
	play_click()
	await get_tree().create_timer(0.15).timeout
	get_tree().change_scene_to_file("res://Scenes/file/main_menu.tscn")
