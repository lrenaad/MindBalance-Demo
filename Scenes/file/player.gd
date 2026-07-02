extends CharacterBody2D

@export var speed: float = 200.0

@export var laptop_area: Area2D
@export var interact_label: Label
@export var laptop_email_panel: Control

@export var scam_question_panel: Control
@export var guide_character: TextureRect
@export var dialogue_label: Label
@export var yes_open_button: Button
@export var no_check_button: Button
@export var feedback_label: Label
@export var got_it_button: Button

@export var coins_label: Label
@export var coin_popup_label: Label

@export var thinking_texture: Texture2D
@export var sad_texture: Texture2D
@export var happy_texture: Texture2D

@export var click_sound: AudioStreamPlayer
@export var coin_sound: AudioStreamPlayer
@export var correct_sound: AudioStreamPlayer
@export var wrong_sound: AudioStreamPlayer

var can_interact: bool = false
var email_open: bool = false
var coins: int = 0
var laptop_reward_claimed: bool = false

@export var back_button: TextureButton
@export var walk_sound: AudioStreamPlayer



func _ready():
	if interact_label != null:
		interact_label.visible = false
	
	if laptop_email_panel != null:
		laptop_email_panel.visible = false
	
	if scam_question_panel != null:
		scam_question_panel.visible = false
	
	if feedback_label != null:
		feedback_label.visible = false
	
	if got_it_button != null:
		got_it_button.visible = false
		if not got_it_button.pressed.is_connected(_on_got_it_button_pressed):
			got_it_button.pressed.connect(_on_got_it_button_pressed)
	
	if coin_popup_label != null:
		coin_popup_label.visible = false
	
	if yes_open_button != null:
		yes_open_button.visible = true
		if not yes_open_button.pressed.is_connected(_on_yes_open_button_pressed):
			yes_open_button.pressed.connect(_on_yes_open_button_pressed)
	
	if no_check_button != null:
		no_check_button.visible = true
		if not no_check_button.pressed.is_connected(_on_no_check_button_pressed):
			no_check_button.pressed.connect(_on_no_check_button_pressed)
	
	if back_button != null:
		back_button.visible = true
		back_button.disabled = false
		back_button.z_index = 999
		back_button.mouse_filter = Control.MOUSE_FILTER_STOP
		back_button.move_to_front()
	
		if not back_button.pressed.is_connected(_on_back_button_pressed):
			back_button.pressed.connect(_on_back_button_pressed)
			
	
	force_show_back_button()
	update_coins_display()


func _physics_process(delta):
	if email_open:
		velocity = Vector2.ZERO
		update_walk_sound(false)
		
		if Input.is_key_pressed(KEY_ESCAPE):
			close_email()
		
		return
	
	var direction = Vector2.ZERO
	
	if Input.is_key_pressed(KEY_D) or Input.is_action_pressed("ui_right"):
		direction.x += 1
	
	if Input.is_key_pressed(KEY_A) or Input.is_action_pressed("ui_left"):
		direction.x -= 1
	
	if Input.is_key_pressed(KEY_S) or Input.is_action_pressed("ui_down"):
		direction.y += 1
	
	if Input.is_key_pressed(KEY_W) or Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
	
	update_walk_sound(direction != Vector2.ZERO)
	check_laptop_distance()
	
	if can_interact and Input.is_key_pressed(KEY_E) and email_open == false:
		open_email()


func check_laptop_distance():
	if laptop_area == null or interact_label == null:
		return
	
	var laptop_center = laptop_area.global_position
	
	var laptop_collision = laptop_area.get_node_or_null("CollisionShape2D")
	if laptop_collision != null:
		laptop_center = laptop_collision.global_position
	
	var distance = global_position.distance_to(laptop_center)
	
	if distance < 500 and email_open == false:
		interact_label.visible = true
		can_interact = true
	else:
		interact_label.visible = false
		can_interact = false


func open_email():
	if laptop_email_panel == null:
		return
	
	play_sound(click_sound)
	update_walk_sound(false)
	
	laptop_email_panel.visible = true
	interact_label.visible = false
	email_open = true
	force_show_back_button()
	show_question_dialogue()


func close_email():
	if laptop_email_panel != null:
		laptop_email_panel.visible = false
	
	if scam_question_panel != null:
		scam_question_panel.visible = false
	
	if feedback_label != null:
		feedback_label.visible = false
	
	if got_it_button != null:
		got_it_button.visible = false
	
	if dialogue_label != null:
		dialogue_label.visible = true
	
	if yes_open_button != null:
		yes_open_button.visible = true
	
	if no_check_button != null:
		no_check_button.visible = true
	
	email_open = false


func show_question_dialogue():
	if scam_question_panel == null:
		return
	
	scam_question_panel.visible = true
	
	if guide_character != null and thinking_texture != null:
		guide_character.texture = thinking_texture
	
	if dialogue_label != null:
		dialogue_label.visible = true
		dialogue_label.text = "هل سوف تفتح هذا الرابط؟"
	
	if yes_open_button != null:
		yes_open_button.visible = true
	
	if no_check_button != null:
		no_check_button.visible = true
	
	if feedback_label != null:
		feedback_label.visible = false
	
	if got_it_button != null:
		got_it_button.visible = false


func _on_yes_open_button_pressed():
	play_sound(click_sound)
	show_feedback(false)


func _on_no_check_button_pressed():
	play_sound(click_sound)
	
	if laptop_reward_claimed == false:
		add_coins(10)
		laptop_reward_claimed = true
		show_coin_popup(10)
		GameData.complete_fraud_level()
	
	show_feedback(true)


func show_feedback(player_answered_correctly: bool):
	if dialogue_label != null:
		dialogue_label.visible = false
	
	if yes_open_button != null:
		yes_open_button.visible = false
	
	if no_check_button != null:
		no_check_button.visible = false
	
	if feedback_label == null:
		return
	
	feedback_label.visible = true
	
	if got_it_button != null:
		got_it_button.visible = true
	
	if player_answered_correctly:
		play_sound(correct_sound)
		
		if guide_character != null and happy_texture != null:
			guide_character.texture = happy_texture
		
		feedback_label.text = "أحسنت! قرارك صحيح.\nهذا الرابط غير آمن.\n\nعلامات الاحتيال:\n• البريد ينتهي بـ gmail.com.\n• البنوك لا تستخدم عادة Gmail.\n• توجد أخطاء إملائية.\n• الرابط غريب وغير موثوق."
	else:
		play_sound(wrong_sound)
		
		if guide_character != null and sad_texture != null:
			guide_character.texture = sad_texture
		
		feedback_label.text = "انتبه! هذا الرابط غير آمن.\n\nلا تفتح روابط مشبوهة.\nالبريد ينتهي بـ gmail.com، وهذا غير مناسب لحساب بنك رسمي.\nكما توجد أخطاء إملائية والرابط غريب."


func _on_got_it_button_pressed():
	play_sound(click_sound)
	close_email()


func _on_back_button_pressed():
	play_sound(click_sound)
	update_walk_sound(false)
	
	var tree = get_tree()
	await tree.create_timer(0.15).timeout
	tree.change_scene_to_file("res://Scenes/file/level_3.tscn")


func add_coins(amount: int):
	GameData.add_coins(amount)
	update_coins_display()
	play_sound(coin_sound)


func update_coins_display():
	if coins_label != null:
		coins_label.text = str(GameData.coins)


func show_coin_popup(amount: int):
	if coin_popup_label == null:
		return
	
	coin_popup_label.text = "+" + str(amount) + " Coins"
	coin_popup_label.visible = true
	
	await get_tree().create_timer(1.2).timeout
	
	if coin_popup_label != null:
		coin_popup_label.visible = false


func play_sound(sound_player: AudioStreamPlayer):
	if sound_player != null:
		sound_player.stop()
		sound_player.play()


func update_walk_sound(is_moving: bool):
	if walk_sound == null:
		return
	
	if is_moving:
		if not walk_sound.playing:
			walk_sound.play()
	else:
		if walk_sound.playing:
			walk_sound.stop()
			
func force_show_back_button():
	if back_button == null:
		return
	
	back_button.visible = true
	back_button.disabled = false
	back_button.z_index = 999
	back_button.mouse_filter = Control.MOUSE_FILTER_STOP
	back_button.move_to_front()
