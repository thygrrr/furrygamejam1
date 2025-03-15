class_name grid_occupant
extends Node3D

func _ready() -> void:
	Grid.write(global_position, self)
