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
	
	var username: String = $Interface/MainContainer/UsernameContainer/UsernameEdit.text
	var password: String = $Interface/MainContainer/UsernameContainer/PasswordEdit.text
	var score: int = $Interface/ScoreLabel.text.to_int()
	var level: int = $Interface/OptionsPage/Container/LevelSlider.value
	if $Interface/MainContainer/UsernameContainer/UsernameEdit.text:
		var success: bool = await Requests.submit_score(username, password, score, level)
		if not success:
			print('Failed to submit score')
			return
		
		var leaderboard: Dictionary = await Requests.get_scores()
		$Interface/LeaderBoardContainer.show()
		$Interface/LeaderBoardContainer/LeaderBoard.set_leaderboard(leaderboard)

func _unhandled_input(event):
	if event.is_action_pressed("fullscreen"):
		print(DisplayServer.window_get_mode())
		match DisplayServer.window_get_mode():
			DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			_:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
