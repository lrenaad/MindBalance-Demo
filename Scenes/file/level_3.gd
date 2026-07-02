extends Control

@onready var fraud_button = get_node_or_null("FraudButton")
@onready var need_want_button = get_node_or_null("NeedWantButton")
@onready var saving_button = get_node_or_null("SavingButton")
@onready var life_balance_button = get_node_or_null("LifeBalanceButton")

@onready var store_button = get_node_or_null("StoreButton")
@onready var achievements_button = get_node_or_null("AchievementsButton")
@onready var back_button = get_node_or_null("BackButton")

@onready var coins_label = get_node_or_null("CoinsLabel")
@onready var level_label = get_node_or_null("LevelLabel")

@onready var click_sound = get_node_or_null("ClickSound")


func _ready() -> void:
	update_coins()
	setup_buttons()
	



func update_coins() -> void:
	if coins_label != null:
		coins_label.text = str(GameData.coins)
	
	if level_label != null:
		level_label.text = "1"


func setup_buttons() -> void:
	if fraud_button != null:
		fraud_button.disabled = false
		fraud_button.modulate = Color(1, 1, 1, 1)
		if not fraud_button.pressed.is_connected(_on_fraud_pressed):
			fraud_button.pressed.connect(_on_fraud_pressed)
	
	lock_button(need_want_button)
	lock_button(saving_button)
	lock_button(life_balance_button)
	
	if store_button != null:
		store_button.disabled = false
		if not store_button.pressed.is_connected(_on_store_pressed):
			store_button.pressed.connect(_on_store_pressed)
	
	if achievements_button != null:
		achievements_button.disabled = false
		if not achievements_button.pressed.is_connected(_on_achievements_pressed):
			achievements_button.pressed.connect(_on_achievements_pressed)
	
	if back_button != null:
		back_button.disabled = false
		if not back_button.pressed.is_connected(_on_back_pressed):
			back_button.pressed.connect(_on_back_pressed)


func lock_button(button) -> void:
	if button == null:
		return
	
	button.disabled = true
	button.modulate = Color(0.45, 0.45, 0.45, 0.75)


func play_click() -> void:
	if click_sound != null:
		click_sound.stop()
		click_sound.play()


func _on_fraud_pressed() -> void:
	play_click()
	await get_tree().create_timer(0.15).timeout
	get_tree().change_scene_to_file("res://Scenes/file/fraud_level.tscn")


func _on_back_pressed() -> void:
	play_click()
	await get_tree().create_timer(0.15).timeout
	get_tree().change_scene_to_file("res://Scenes/file/main_menu.tscn")


func _on_store_pressed() -> void:
	play_click()
	print("المتجر لاحقًا")


func _on_achievements_pressed() -> void:
	play_click()
	print("الإنجازات لاحقًا")
