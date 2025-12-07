extends Node2D

signal _anything_pressed

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		_anything_pressed.emit()

func _ready() -> void:
	TimeScaleService.set_time_scale(0)
	await _anything_pressed
	TimeScaleService.set_time_scale(1)
	SignalBus.game_started.emit()
