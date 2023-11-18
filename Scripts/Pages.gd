extends Control


func _on_back_button_pressed() -> void:
	self.hide()


func _on_link_clicked(meta) -> void:
	
	var link = str(meta)
	
	if link == "Options.tscn":
		self.hide()
		get_parent().get_node("OptionsPage").call("show")
	else:
		OS.shell_open(link)
