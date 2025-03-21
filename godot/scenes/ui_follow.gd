extends Control

@export var target : Node3D
var other : Node3D

func _orient():
	if not other:
		return

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


func show_for_critter(critter : Critter):
	pass

func _process(_delta: float) -> void:
	if (!visible):
		return

	var camera = get_viewport().get_camera_3d()
	if camera and target:
		var screen_position = camera.unproject_position(target.global_position)
		global_position = screen_position
		_orient()
