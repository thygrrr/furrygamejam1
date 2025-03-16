extends Node3D

@export var excitement : float = 3.0

@onready var mesh : Node3D = self

var noise : FastNoiseLite
var age : float

func _ready() -> void:
	noise = FastNoiseLite.new()
	age = randf() * 100.0
	excitement += randf()

func _process(delta: float):
	age += delta * excitement
	var breath = (sin(age) + 1.0) * 0.03
	mesh.scale = Vector3.ONE + Vector3(noise.get_noise_2d(age, 1) * 0.2, breath, noise.get_noise_2d(age, 7) * 0.2)
