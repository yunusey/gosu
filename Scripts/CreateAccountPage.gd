extends Control


func _on_back_button_pressed() -> void:
	self.hide()


func _on_submit_button_pressed():
	var username: String = $UsernameEdit.text
	var password: String = $PasswordEdit.text
	var is_valid: bool = await Requests.create_user(username, password)
	if not is_valid:
		$UsernameExistsLabel.show()


func _on_link_clicked(meta) -> void:
	var link = str(meta)
	
	if link == "Options.tscn":
		self.hide()
		get_parent().get_node("OptionsPage").call("show")
	else:
		OS.shell_open(link)


func set_props(username: String, password: String) -> void:
	$UsernameEdit.text = username
	$PasswordEdit.text = password

