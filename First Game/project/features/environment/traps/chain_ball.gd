@tool
extends Node2D

@export_group("General")
@export var _length_steps: int = 3
@export var _start_angle: float = 0

@export_group("Spin")
@export var _spin_direction: float = -1
@export var _spin_duration: float = 2

@export_group("Grid")
@export var _length_step_size: float = 16
@export var _grid_size: float = 16

func _ready():
	if !Engine.is_editor_hint():
		_set_up()

func _process(_delta):
	if Engine.is_editor_hint():
		_set_up()

func _set_up():
	var length = _length_step_size * _length_steps
	$Ball.position = Vector2(0, -length)
	$Chain.position = Vector2(0, -length * 0.5)
	$Chain.region_rect = Rect2(0, 0, 16, length)

	global_position = Vector2(floor(global_position.x / _grid_size) * _grid_size + _grid_size * 0.5,
						floor(global_position.y / _grid_size) * _grid_size + _grid_size * 0.5)
	rotation = deg_to_rad(_start_angle)

	if !Engine.is_editor_hint():
		var tween = get_tree().create_tween().set_loops()
		tween.tween_property($".", "rotation", deg_to_rad(360 * _spin_direction), _spin_duration).as_relative()