extends Node

var timer = 0
var was_goal_reached = false

func _ready():
	Events.goal_reached.connect(_on_goal_reached)

func _process(delta):
	if was_goal_reached:
		return
	timer += delta
	Events.timer_changed.emit(timer)

func _on_goal_reached():
	was_goal_reached = true
