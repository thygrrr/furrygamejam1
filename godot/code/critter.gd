extends Node3D
class_name Critter

@onready var mesh : Node3D = %view.get_child(0)

var noise : FastNoiseLite
var age : float
@export var excitement : float = 3.0

func _ready() -> void:
	noise = FastNoiseLite.new()
	age = randf() * 100.0
	excitement += randf()

	prints("Critter._ready():", name)
	Grid.write(global_position, self)

func _process(delta: float):
	age += delta * excitement
	var breath = (sin(age) + 1.0) * 0.03
	mesh.scale = Vector3.ONE + Vector3(noise.get_noise_2d(age, 1) * 0.4, breath, noise.get_noise_2d(age, 7) * 0.4)
