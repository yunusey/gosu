extends VBoxContainer


const RANK_LABEL_FORMAT_STRING: String = "{rank}. {username}"
const SCORE_LABEL_FORMAT_STRING: String = "Score: {score}"
func set_element(rank: int, username: String, score: int):
	$RankLabel.text = RANK_LABEL_FORMAT_STRING.format({
		"rank": rank,
		"username": username
	})
	$ScoreLabel.text = SCORE_LABEL_FORMAT_STRING.format({
		"score": score
	})
