extends Node3D

@export var target : Node3D
@export var follow_position : bool = true
@export var follow_rotation : bool = true

func _process(_delta: float) -> void:
	if target:
		if follow_position:
			global_position = target.global_position
		if follow_rotation:
			global_rotation = target.global_rotation
