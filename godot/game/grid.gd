extends Node

@export var size : int = 101

var grid : Array[Array] = []

func _enter_tree() -> void:
	grid.resize(size)
	for row in grid:
		row.resize(size)


func read(pos: Vector3) -> Node:
	var center = float(size/2)
	return grid[roundi(center+pos.x)][roundi(center+pos.z)]

func write(pos: Vector3, node: Node) -> bool:
	var center = float(size/2)
	if not (read(pos)):
		grid[roundi(center+pos.x)][roundi(center+pos.z)] = node
		return true
	return false


func clear(pos: Vector3) -> void:
	var center = float(size/2)
	grid[roundi(center+pos.x)][roundi(center+pos.z)] = null
