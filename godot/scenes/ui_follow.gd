extends Control

@export var target : Node3D
var other : Node3D

func _orient():
	if (other.global_position - target.global_position).length() > 1.1:
		hide()
		return

	if other.global_basis.z.dot(target.global_basis.z) > -0.5:
		hide()
		return

	if other.global_basis.y.dot(target.global_basis.y) > 0.5:
		rotation_degrees = 0
		show()
		return

	if other.global_basis.y.dot(target.global_basis.y) < -0.5:
		rotation_degrees = 180
		show()
		return

	if other.global_basis.x.dot(target.global_basis.y) > 0.5:
		rotation_degrees = 90
		show()
		return

	if other.global_basis.x.dot(target.global_basis.y) < -0.5:
		rotation_degrees = 90
		show()
		return

	hide()

func _check_self(other: Node3D):
	visible = (other == target)
	_orient()

func show_for_critter(critter : Critter):
	other = critter.view
	critter.faces.connect(_check_self)
	_orient()
	show()

func _position():
	var camera = get_viewport().get_camera_3d()
	if camera and target:
		var screen_position := camera.unproject_position(target.global_position)
		global_position = global_position * 0.8 + 0.2 * screen_position

func _process(_delta: float) -> void:
	_position()
