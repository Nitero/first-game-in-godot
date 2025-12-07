extends Node2D

@onready var _confetti_particles = $ConfettiParticles

func _ready() -> void:
	_confetti_particles.one_shot = true
	_confetti_particles.emitting = false

func _on_trigger_body_entered(_body: Node2D) -> void:
	_confetti_particles.emitting = true
	SignalBus.goal_reached.emit()
	$Sound.play()
