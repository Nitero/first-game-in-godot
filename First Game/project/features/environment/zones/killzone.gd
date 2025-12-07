extends Area2D

@export var horizontal_knockback: float = 200
@export var vertical_knockback: float = 50

func _on_body_entered(body):
	var player = body as Player
	if player:
		var knockback = (player.global_position - global_position).normalized() * horizontal_knockback
		knockback += Vector2.UP * vertical_knockback
		player.die(knockback)
