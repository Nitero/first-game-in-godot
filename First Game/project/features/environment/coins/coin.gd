extends Area2D

@onready var animation_player = $AnimationPlayer

func _on_body_entered(_body):
	Events.coin_collected.emit()
	animation_player.play("pickup")