extends Node2D

var hitball: Resource = preload("res://Hitball.tscn")


func _on_timer_timeout() -> void:
	var instance = hitball.instantiate()
	instance.counter = $Interface/ScoreLabel
	instance.audio_player = $AudioStreamPlayer2D
	
	var radius: float = instance.get_radius()
	instance.position = Vector2(
		randf_range(0 + radius, 1920 - radius),
		randf_range(0 + radius, 1080 - radius)
	)
	
	add_child(instance)
	
	instance.game_over.connect(_on_game_over)
	instance.game_over.connect($Interface._on_game_over)

	$Timer.start()


func _on_start_game() -> void:
	$Timer.start()

func _on_game_over() -> void:
	get_tree().call_group("hitballs", "queue_free")
	$Timer.stop()
	
	if $Interface/MainContainer/UsernameContainer/UsernameEdit.text:
		var data = []
		if FileAccess.file_exists("user://scores.json"):
			var data_path = FileAccess.open("user://scores.json", FileAccess.READ)
			data = JSON.parse_string(data_path.get_as_text())
			
		var user_data: Dictionary = {
			"username": $Interface/MainContainer/UsernameContainer/UsernameEdit.text,
			"level": $Interface/OptionsPage/Container/LevelSlider.value,
			"score": int($Interface/ScoreLabel.text)
		}
		
		data.append(user_data)
		
		var data_path = FileAccess.open("user://scores.json", FileAccess.WRITE)
		data_path.store_string(JSON.stringify(data))

func _unhandled_input(event):
	if event.is_action_pressed("fullscreen"):
		print(DisplayServer.window_get_mode())
		match DisplayServer.window_get_mode():
			DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			_:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
