extends Node

#TODO: instead use a HFSM plugin

var was_restarted = false

func _ready() -> void:
	Events.player_died.connect(_on_player_died)
	Events.player_restarted.connect(_on_player_restarted)

func _on_player_died():
	TimeScaleService.set_time_scale(0.25)
	await get_tree().create_timer(0.5).timeout
	restart()

func _on_player_restarted():
	restart()

func restart():
	TimeScaleService.set_time_scale(1)
	if was_restarted:
		return
	was_restarted = true
	get_tree().reload_current_scene()
