class_name Obstacle
extends Node3D

func _ready() -> void:
	Grid.write(global_position, self)
