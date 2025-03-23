extends Node

@export var size : int = 31

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
		return LevelManager # Hack, don't have another good one for out of bounds rn

	return grid[x][z]

func write(pos: Vector3, node: Node) -> bool:
	var center = float(size/2)
	var x = roundi(center+pos.x)
	var z = roundi(center+pos.z)

	if (x >= size) or (z >= size) or (x < 0) or (z < 0):
		return false

	grid[x][z] = node
	return true


func clear(pos: Vector3) -> void:
	var center = float(size/2)
	var x = roundi(center+pos.x)
	var z = roundi(center+pos.z)
	grid[x][z] = null
