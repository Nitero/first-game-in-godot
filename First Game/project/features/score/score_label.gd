@tool
extends Label

@export var _format: String = "You collected %s coins."

func _ready():
	if !Engine.is_editor_hint():
		_on_score_changed(0);
		SignalBus.score_changed.connect(_on_score_changed)

func _process(_delta):
	if Engine.is_editor_hint():
		_on_score_changed(9999);

func _on_score_changed(score):
	text = _format % str(score)
