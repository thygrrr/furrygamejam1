extends Node3D
class_name Critter

func _ready() -> void:
	prints("Critter._ready():", name)
	Grid.write(global_position, self)

func _move_sound() -> void:
	$AudioStreamPlayer3D.play()
