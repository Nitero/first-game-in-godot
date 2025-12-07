extends Label


func _ready() -> void:
	SignalBus.game_started.connect(_on_game_started)

func _on_game_started():
	hide()
