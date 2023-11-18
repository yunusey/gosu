extends VBoxContainer


var rank_element: Resource = preload("res://RankContainer.tscn")


func _ready():
	if not FileAccess.file_exists("user://scores.json"):
		return
		
	var data_path = FileAccess.open("user://scores.json", FileAccess.READ)
	var data: Array = JSON.parse_string(data_path.get_as_text())
	
	# I am aware that sorting the data each time the application opens is not a good way :D
	# However, I don't think it would be a huge problem either since we won't have hundreds
	# of thousands of players ;D
	data.sort_custom(func(a, b): return a["score"] * a["level"] > b["score"] * b["level"])
	
	for rank in range(data.size()):
		var i = data[rank]
		var score: int = i["level"] * i["score"]
		var username: String = i["username"]
		
		var element = rank_element.instantiate()
		element.set_element(rank + 1, username, score)
		
		add_child(element)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
