extends Node2D

@onready var _confetti_particles: CPUParticles2D = $ConfettiParticles
var _confetti_finished = true

func _ready() -> void:
	_confetti_particles.one_shot = true
	_confetti_particles.emitting = false
	_confetti_particles.finished.connect(_on_confetti_particles_finished)

func _on_confetti_particles_finished():
	_confetti_finished = true

func _on_trigger_body_entered(_body: Node2D) -> void:
	if _confetti_finished:
		$Sound.play()
	_confetti_finished = false
	_confetti_particles.emitting = true
	SignalBus.goal_reached.emit()