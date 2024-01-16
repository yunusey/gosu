extends VBoxContainer


var rank_element: Resource = preload("res://RankContainer.tscn")


func _ready():
	set_leaderboard(await Requests.get_scores())


func set_leaderboard(leaderboard: Dictionary):
	# I am aware that sorting the data each time is not good :D
	# However, I don't think it would be a huge problem either since we won't have hundreds
	# of thousands of players ;D
	for child in get_children():
		if not child is RichTextLabel:
			child.queue_free()

	var leaders: Array[Dictionary] = []
	for i in leaderboard:
		leaders.append({
			"username": i,
			"level": leaderboard[i]["level"],
			"score": leaderboard[i]["score"],
		})
	leaders.sort_custom(func(a, b): return a["level"] * a["score"] > b["level"] * b["score"])

	for rank in range(leaders.size()):
		var i = leaders[rank]
		var score: int = i["level"] * i["score"]
		var username: String = i["username"]
		
		var element = rank_element.instantiate()
		element.set_element(rank + 1, username, score)
		
		add_child(element)
