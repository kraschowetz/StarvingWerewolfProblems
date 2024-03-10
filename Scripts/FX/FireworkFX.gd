extends Node2D

@export var particles: Array[GPUParticles2D]

func _ready() -> void:
	for i in range(particles.size()):
		particles[i].emitting = true
