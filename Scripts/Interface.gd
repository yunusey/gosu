extends CanvasLayer

signal start_game

func _ready() -> void:
	$ScoreLabel.hide()
	$MainContainer.show()
	
	$OptionsPage/Container/LevelSlider.value_changed.connect(_on_level_changed)


func _on_start_button_pressed() -> void:
	var username: String = $MainContainer/UsernameContainer/UsernameEdit.text
	var password: String = $MainContainer/UsernameContainer/PasswordEdit.text
	var result: Dictionary = await Requests.check_login(username, password)
	if result["is_authorized"]:
		$MainContainer.hide()
		$LeaderBoardContainer.hide()
		$ScoreLabel.text = "0"
		$ScoreLabel.show()
		$MainContainer/UsernameContainer/PasswordIncorrectLabel.hide()
		
		start_game.emit()
	
	elif not result["is_username_found"]:
		$CreateAccountPage.show()
		$CreateAccountPage.set_props(username, password)
		$MainContainer/UsernameContainer/PasswordIncorrectLabel.hide()
	
	else:
		$MainContainer/UsernameContainer/PasswordIncorrectLabel.show()


func _on_game_over() -> void:
	$MainContainer.show()
	$MainContainer/UsernameContainer/PasswordIncorrectLabel.hide()
	$LeaderBoardContainer.show()

const ALLOWED_CHARS: String = "[A-Za-z_]"
var regex: RegEx = RegEx.create_from_string(ALLOWED_CHARS)

func _on_username_changed(new_text: String) -> void:
	var old_caret_position = $MainContainer/UsernameContainer/UsernameEdit.caret_column
	
	var word: String = ''
	for valid in regex.search_all(new_text):
		word += valid.get_string()
		
	$MainContainer/UsernameContainer/UsernameEdit.set_text(word)
	$MainContainer/UsernameContainer/UsernameEdit.caret_column = old_caret_position

func _on_about_button_pressed() -> void:
	$AboutPage.show()

func _on_help_button_pressed() -> void:
	$HelpPage.show()


func _on_options_button_pressed() -> void:
	$OptionsPage.show()

func _on_level_changed(value: int) -> void:
	var timer: Timer = get_parent().find_child("Timer")
	timer.wait_time = 5. / value
