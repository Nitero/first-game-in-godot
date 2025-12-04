extends Node

#TODO: instead use a HFSM plugin

func _ready() -> void:
	Events.player_died.connect(_on_player_died)

func _on_player_died():
	TimeScaleService.set_time_scale(0.5)
	await get_tree().create_timer(0.5).timeout
	TimeScaleService.set_time_scale(1)
	get_tree().reload_current_scene()
