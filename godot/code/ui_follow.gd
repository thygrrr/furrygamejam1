extends Control

@export var target : Interactable

@onready var content : Control = $Content

var critter_view : Node3D


func _check_self(critter: Node3D):
	visible = (critter == target)
	if visible:
		target.highlight.play()
		_orient()


func show_for_critter(critter : Critter):
	critter_view = critter.view
	critter.faces.connect(_check_self)
	hide()


func _position():
	var camera = get_viewport().get_camera_3d()
	if camera and target:
		var screen_position := camera.unproject_position(target.global_position)
		global_position = global_position * 0.8 + 0.2 * screen_position


func _process(_delta: float) -> void:
	_position()


func _orient():
	if (critter_view.global_position - target.global_position).length() > 1.1:
		hide()
		return

	if critter_view.global_basis.z.dot(target.global_basis.z) > -0.5:
		hide()
		return

	show()

	if target.global_basis.z.dot(Vector3.LEFT) > 0.5:
		_orient_left()
	elif target.global_basis.z.dot(Vector3.RIGHT) > 0.5:
		_orient_right()
	elif target.global_basis.z.dot(Vector3.FORWARD) > 0.5:
		_orient_forward()
	elif target.global_basis.z.dot(Vector3.BACK) > 0.5:
		_orient_back()
	else:
		hide()


func _orient_left():
	if critter_view.global_basis.y.dot(target.global_basis.y) > 0.5:
		content.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT, true)
		content.position = content.size * Vector2(0, -1) # I hate godot bugs
		rotation_degrees = 0

	elif critter_view.global_basis.x.dot(target.global_basis.y) > 0.5:
		content.set_anchors_preset(Control.PRESET_BOTTOM_LEFT, true)
		content.position = content.size * Vector2(-1, -1)
		rotation_degrees = 90

	elif critter_view.global_basis.y.dot(target.global_basis.y) < -0.5:
		content.set_anchors_preset(Control.PRESET_TOP_RIGHT, true)
		content.position = content.size * Vector2(-1, 0) # I hate godot bugsewerew
		rotation_degrees = 180

	elif critter_view.global_basis.x.dot(target.global_basis.y) < -0.5:
		content.set_anchors_preset(Control.PRESET_TOP_RIGHT, true)
		content.position = content.size * Vector2(0, 0)
		rotation_degrees = -90

	else:
		assert(false, "No rotation found?!")



func _orient_right():
	if critter_view.global_basis.y.dot(target.global_basis.y) > 0.5:
		content.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT, true)
		content.position = content.size * Vector2(-1, -1) # I hate godot bugs
		rotation_degrees = 0

	elif critter_view.global_basis.x.dot(target.global_basis.y) > 0.5:
		content.set_anchors_preset(Control.PRESET_BOTTOM_LEFT, true)
		content.position = content.size * Vector2(-1, 0)
		rotation_degrees = 90

	elif critter_view.global_basis.y.dot(target.global_basis.y) < -0.5:
		content.set_anchors_preset(Control.PRESET_TOP_RIGHT, true)
		content.position = content.size * Vector2(0, 0) # I hate godot bugsewerew
		rotation_degrees = 180

	elif critter_view.global_basis.x.dot(target.global_basis.y) < -0.5:
		content.set_anchors_preset(Control.PRESET_TOP_RIGHT, true)
		content.position = content.size * Vector2(0, -1)
		rotation_degrees = -90

	else:
		assert(false, "No rotation found?!")


func _orient_forward():
	if critter_view.global_basis.y.dot(target.global_basis.y) > 0.5:
		content.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT, true)
		content.position = content.size * Vector2(0, 0) # I hate godot bugs
		rotation_degrees = 0

	elif critter_view.global_basis.x.dot(target.global_basis.y) > 0.5:
		content.set_anchors_preset(Control.PRESET_BOTTOM_LEFT, true)
		content.position = content.size * Vector2(0, 0)
		rotation_degrees = 90

	elif critter_view.global_basis.y.dot(target.global_basis.y) < -0.5:
		content.set_anchors_preset(Control.PRESET_TOP_RIGHT, true)
		content.position = content.size * Vector2(-1, -1) # I hate godot bugsewerew
		rotation_degrees = 180

	elif critter_view.global_basis.x.dot(target.global_basis.y) < -0.5:
		content.set_anchors_preset(Control.PRESET_TOP_RIGHT, true)
		content.position = content.size * Vector2(-1, -1)
		rotation_degrees = -90

	else:
		assert(false, "No rotation found?!")



func _orient_back():
	if critter_view.global_basis.y.dot(target.global_basis.y) > 0.5:
		content.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT, true)
		content.position = content.size * Vector2(0, -1) # I hate godot bugs
		rotation_degrees = 0

	elif critter_view.global_basis.y.dot(target.global_basis.y) < -0.5:
		content.set_anchors_preset(Control.PRESET_TOP_RIGHT, true)
		content.position = content.size * Vector2(-1, 0) # I hate godot bugsewerew
		rotation_degrees = 180

	elif critter_view.global_basis.x.dot(target.global_basis.y) > 0.5:
		content.set_anchors_preset(Control.PRESET_BOTTOM_LEFT, true)
		content.position = content.size * Vector2(-1, -1)
		rotation_degrees = 90

	elif critter_view.global_basis.x.dot(target.global_basis.y) < -0.5:
		content.set_anchors_preset(Control.PRESET_TOP_RIGHT, true)
		content.position = content.size * Vector2(0, 0)
		rotation_degrees = -90

	else:
		assert(false, "No rotation found?!")
