class_name Obstacle
extends Node3D

@export var group_as_parent : bool = false
@export var include_children : bool = false
func _ready() -> void:
	if group_as_parent:
		Grid.write(global_position, get_parent_node_3d())
	else:
		Grid.write(global_position, self)

	if include_children:
		for child in get_children():
			if child is not Node3D:
				continue
			Grid.write(child.global_position, self)
