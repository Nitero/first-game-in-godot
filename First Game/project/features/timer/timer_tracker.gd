extends Node

var _timer = 0
var _was_goal_reached = false

func _ready():
	SignalBus.goal_reached.connect(_on_goal_reached)

func _process(delta):
	if _was_goal_reached:
		return
	_timer += delta
	SignalBus.timer_changed.emit(_timer)

func _on_goal_reached():
	_was_goal_reached = true
