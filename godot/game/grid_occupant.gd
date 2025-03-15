class_name grid_occupant
extends Node3D

func _ready() -> void:
	print(name, "_ready()")
	Grid.write(global_position, self)
