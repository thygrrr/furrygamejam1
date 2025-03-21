class_name Interactable
extends Node3D

func _ready() -> void:
	prints("Interactable._ready():", name)
	Grid.write(global_position, self)
