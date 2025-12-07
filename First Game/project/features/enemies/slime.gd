extends Node2D

const SPEED = 60

var _direction = 1

@onready var _ray_cast_right = $RayCastRight
@onready var _ray_cast_left = $RayCastLeft
@onready var _animated_sprite = $AnimatedSprite2D

func _process(delta):
	if _ray_cast_right.is_colliding():
		_direction = -1
		_animated_sprite.flip_h = true
	if _ray_cast_left.is_colliding():
		_direction = 1
		_animated_sprite.flip_h = false
	
	position.x += _direction * SPEED * delta
