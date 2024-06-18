extends CanvasLayer


func set_score(score: int) -> void:
	%ScoreLabel.text = "分數: %d" % [score]
