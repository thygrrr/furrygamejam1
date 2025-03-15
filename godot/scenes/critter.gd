extends Node3D

var goal_rotation := Quaternion.IDENTITY

var rotate_left := Quaternion(Vector3.BACK, deg_to_rad(90))
var rotate_right := Quaternion(Vector3.FORWARD, deg_to_rad(90))
var rotate_up := Quaternion(Vector3.LEFT, deg_to_rad(90))
var rotate_down := Quaternion(Vector3.RIGHT, deg_to_rad(90))

@onready var anchor : Node3D = %anchor
@onready var view : Node3D = %view

func _ready() -> void:
	anchor.top_level = true
	goal_rotation = quaternion
	quaternion = Quaternion.IDENTITY


func _on_animatable_body_3d_mouse_entered() -> void:
	pass # Replace with function body.


func _on_animatable_body_3d_mouse_exited() -> void:
	pass # Replace with function body.

func _process(_delta : float) -> void:
	view.quaternion = view.quaternion.slerp(anchor.quaternion * goal_rotation, pow(0.1, _delta * 120.0))

	var p := anchor.global_position
	anchor.global_position = p.lerp(global_position, pow(0.1, _delta * 120.0))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		global_position -= Vector3(1, 0, 0)
		goal_rotation = rotate_left * goal_rotation

	if event.is_action_pressed("move_right"):
		global_position += Vector3(1, 0, 0)
		goal_rotation = rotate_right * goal_rotation


	if event.is_action_pressed("move_up"):
		global_position -= Vector3(0, 0, 1)
		goal_rotation = rotate_up * goal_rotation

	if event.is_action_pressed("move_down"):
		global_position += Vector3(0, 0, 1)
		goal_rotation = rotate_down * goal_rotation
