extends Node

var _score = 0

func _ready():
	SignalBus.coin_collected.connect(_on_coin_collected)
	
func _on_coin_collected():
	_add_point()

func _add_point():
	_score += 1
	SignalBus.score_changed.emit(_score)
