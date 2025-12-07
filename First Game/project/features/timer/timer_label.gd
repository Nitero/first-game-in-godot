@tool
extends Label

@export var format: String = "Time: %s"

func _ready():
	if !Engine.is_editor_hint():
		_on_timer_changed(0);
	Events.timer_changed.connect(_on_timer_changed)

func _process(_delta):
	if Engine.is_editor_hint():
		_on_timer_changed(123.456);

func _on_timer_changed(timer):
	text = format % format_time(timer)

func format_time(time):
	var seconds = int(time)
	var centiseconds = int((time - seconds) * 100)
	return "%d:%02d" % [seconds, centiseconds]
