extends Node

var score = 0

func _ready():
	Events.coin_collected.connect(_on_coin_collected)
	
func _on_coin_collected():
	add_point()

func add_point():
	score += 1
	Events.score_changed.emit(score)
