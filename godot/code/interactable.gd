class_name Interactable
extends Node3D

@onready var view : Node3D = %view

@onready var highlight : AudioStreamPlayer3D = $highlight

func _ready() -> void:
	prints("Interactable._ready():", name)
	Grid.write(global_position, self)
