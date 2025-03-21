extends Node

@export var size : int = 101

var grid : Array[Array] = []

func _enter_tree() -> void:
	reset()

func reset() -> void:
	grid.clear()
	grid.resize(size)
	for row in grid:
		row.resize(size)


func read(pos: Vector3) -> Node:
	var center = float(size/2)
	var x = roundi(center+pos.x)
	var z = roundi(center+pos.z)
	if (x >= size) or (z >= size) or (x < 0) or (z < 0):
		return null
	return grid[x][z]

func write(pos: Vector3, node: Node) -> bool:
	var center = float(size/2)
	var x = roundi(center+pos.x)
	var z = roundi(center+pos.z)
	prints(x, z)
	if (x >= size) or (z >= size) or (x < 0) or (z < 0):
		return false
	if not (read(pos)):
		grid[x][z] = node
		return true
	return false


func clear(pos: Vector3) -> void:
	var center = float(size/2)
	var x = roundi(center+pos.x)
	var z = roundi(center+pos.z)
	grid[x][z] = null
