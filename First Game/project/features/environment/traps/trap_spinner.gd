extends Node

const DIRECTION = -1
const DURATION_PER_SPIN = 2

func _ready() -> void:
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property($"..", "rotation", deg_to_rad(360*DIRECTION), DURATION_PER_SPIN).as_relative()
