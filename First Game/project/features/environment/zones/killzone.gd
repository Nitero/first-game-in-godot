extends Area2D

@export var _horizontal_knockback: float = 200
@export var _vertical_knockback: float = 50

func _on_body_entered(body):
	var player = body as Player
	if player:
		var knockback = (player.global_position - global_position).normalized() * _horizontal_knockback
		knockback += Vector2.UP * _vertical_knockback
		player.die(knockback)
