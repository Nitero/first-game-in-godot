extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var pickup_sound = $PickupSound

func _on_body_entered(_body):
	Events.coin_collected.emit()
	
	animated_sprite.visible = false
	collision_shape.set_deferred("disabled", true)
	pickup_sound.play()
	await pickup_sound.finished
	queue_free()
