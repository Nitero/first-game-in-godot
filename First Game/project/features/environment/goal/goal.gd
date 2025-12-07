extends Node2D

@onready var confetti_particles = $ConfettiParticles

func _ready() -> void:
	confetti_particles.one_shot = true
	confetti_particles.emitting = false

func _on_trigger_body_entered(_body: Node2D) -> void:
	confetti_particles.emitting = true
	Events.goal_reached.emit()
