extends Node3D

var rotate_left := Quaternion(Vector3.BACK, deg_to_rad(90))
var rotate_right := Quaternion(Vector3.FORWARD, deg_to_rad(90))
var rotate_up := Quaternion(Vector3.LEFT, deg_to_rad(90))
var rotate_down := Quaternion(Vector3.RIGHT, deg_to_rad(90))

func _on_animatable_body_3d_mouse_entered() -> void:
	pass # Replace with function body.


func _on_animatable_body_3d_mouse_exited() -> void:
	pass # Replace with function body.

func _process(_delta : float) -> void:
	var view : Node3D = $view
	view.quaternion = view.quaternion.slerp(quaternion, pow(0.1, _delta * 120.0))

	var p := view.global_position
	view.global_position = p.lerp(global_position, pow(0.1, _delta * 120.0))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		global_position -= Vector3(1, 0, 0)
		quaternion = rotate_left * quaternion

	if event.is_action_pressed("move_right"):
		global_position += Vector3(1, 0, 0)
		quaternion = rotate_right * quaternion


	if event.is_action_pressed("move_up"):
		global_position -= Vector3(0, 0, 1)
		quaternion = rotate_up * quaternion

	if event.is_action_pressed("move_down"):
		global_position += Vector3(0, 0, 1)
		quaternion = rotate_down * quaternion
