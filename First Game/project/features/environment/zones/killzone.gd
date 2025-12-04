extends Area2D

func _on_body_entered(body):
	var player = body as Player
	if player:
		player.die()
