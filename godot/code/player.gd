extends Critter
class_name Player

func debug_faces(other: Node3D):
	if other:
		print(other.name)

# Single Entry Point into execution flow.
func _ready() -> void:
	super()
	faces.connect(debug_faces)
	var old_quaternion := quaternion
	quaternion = Quaternion.IDENTITY
	anchor.top_level = true
	goal_rotation = old_quaternion
	from_rotation = goal_rotation
	view.quaternion = goal_rotation



# Smoothly LERP position (TODO: use SmoothRemoteTransform to do this work)
func _process(_delta : float) -> void:
	var k := pow(0.9, _delta * 120.0)
	anchor.global_position = k * anchor.global_position + (1-k) * global_position

	view.quaternion = from_rotation.slerp(goal_rotation, rotation_t)


# Resolve a single input event
func _execute(event: InputEvent) -> void:

	var next_step : Vector3
	var next_flip : Quaternion

	if event.is_action_pressed("move_left"):
		next_step = Vector3.LEFT
		next_flip = flip_left
	elif event.is_action_pressed("move_right"):
		next_step = Vector3.RIGHT
		next_flip = flip_right
	elif event.is_action_pressed("move_up"):
		next_step = Vector3.FORWARD
		next_flip = flip_up
	elif event.is_action_pressed("move_down"):
		next_step = Vector3.BACK
		next_flip = flip_down
	else:
		return

	await move_to(global_position + next_step, next_flip)
