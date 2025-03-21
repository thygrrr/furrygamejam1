extends Control

@export var target : Interactable
var critter_view : Node3D

func _orient():
	if (critter_view.global_position - target.global_position).length() > 1.1:
		hide()
		return

	if critter_view.global_basis.z.dot(target.global_basis.z) > -0.5:
		hide()
		return

	if critter_view.global_basis.y.dot(target.global_basis.y) > 0.5:
		rotation_degrees = 0
		show()
		return

	if critter_view.global_basis.y.dot(target.global_basis.y) < -0.5:
		rotation_degrees = 180
		show()
		return

	if critter_view.global_basis.x.dot(target.global_basis.y) > 0.5:
		rotation_degrees = 90
		show()
		return

	if critter_view.global_basis.x.dot(target.global_basis.y) < -0.5:
		rotation_degrees = 90
		show()
		return

	hide()

func _check_self(critter: Node3D):
	visible = (critter == target)
	if visible:
		target.highlight.play()
		_orient()

func show_for_critter(critter : Critter):
	critter_view = critter.view
	critter.faces.connect(_check_self)

func _position():
	var camera = get_viewport().get_camera_3d()
	if camera and target:
		var screen_position := camera.unproject_position(target.global_position)
		global_position = global_position * 0.8 + 0.2 * screen_position

func _process(_delta: float) -> void:
	_position()
