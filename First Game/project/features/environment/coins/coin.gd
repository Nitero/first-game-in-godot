extends Area2D

@onready var _animation_player = $AnimationPlayer
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _collision_shape = $CollisionShape2D
@onready var _pickup_sound = $PickupSound

func _on_body_entered(_body):
	SignalBus.coin_collected.emit()
	
	_animated_sprite.visible = false
	_collision_shape.set_deferred("disabled", true)
	_pickup_sound.play()
	await _pickup_sound.finished
	queue_free()
