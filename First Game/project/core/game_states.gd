extends Node

#TODO: instead use a HFSM plugin

var _was_restarted = false

func _ready() -> void:
	SignalBus.player_died.connect(_on_player_died)
	SignalBus.player_restarted.connect(_on_player_restarted)

func _on_player_died():
	TimeScaleService.set_time_scale(0.25)
	await get_tree().create_timer(0.5).timeout
	_restart()

func _on_player_restarted():
	_restart()

func _restart():
	TimeScaleService.set_time_scale(1)
	if _was_restarted:
		return
	_was_restarted = true
	get_tree().reload_current_scene()
