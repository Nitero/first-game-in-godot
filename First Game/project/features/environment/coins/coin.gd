extends Area2D

@onready var animation_player = $AnimationPlayer

func _on_body_entered(_body):
	Events.coin_collected.emit()
	animation_player.play("pickup")#TODO: why need animation at all? hide + play sound from code? oh because sound stops when we delete it too soon
	await get_tree().create_timer(1.0).timeout#TODO:take delay from the length of the animation
	queue_free()
