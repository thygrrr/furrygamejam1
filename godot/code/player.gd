extends Node3D

var from_rotation := Quaternion.IDENTITY
var goal_rotation := Quaternion.IDENTITY

var rotation_t : float = 1.0

var flip_left := Quaternion(Vector3.FORWARD, deg_to_rad(90))
var flip_right := Quaternion(Vector3.BACK, deg_to_rad(90))
var flip_up := Quaternion(Vector3.RIGHT, deg_to_rad(90))
var flip_down := Quaternion(Vector3.LEFT, deg_to_rad(90))

@onready var anchor : Node3D = %anchor
@onready var offset : Node3D = %offset
@onready var view : Node3D = %view

var flip : Tween
var input_buffer : Array[InputEvent] = []

# Single Entry Point into execution flow.
func _ready() -> void:
	anchor.top_level = true
	goal_rotation = view.quaternion
	from_rotation = goal_rotation

	quaternion = Quaternion.IDENTITY

	await _main()


# Main event loop, currently dummy condition and processes input indefinitely
func _main() -> void:
	while true:
		if input_buffer:
			await _execute(input_buffer.pop_front())
		else:
			await get_tree().process_frame


# Smoothly LERP position (TODO: use SmoothRemoteTransform to do this work)
func _process(_delta : float) -> void:
	view.quaternion = from_rotation.slerp(goal_rotation, rotation_t)

	var p := anchor.global_position
	anchor.global_position = p.lerp(global_position, pow(0.1, _delta * 120.0))


# Buffer input events
func _input(event: InputEvent) -> void:
	if event.is_action_type() and event.is_pressed():
		input_buffer.append(event)


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

	if Grid.write(global_position + next_step, self):
		Grid.clear(global_position)
		global_position += next_step

		from_rotation = view.quaternion
		goal_rotation *= next_flip

		rotation_t = 0.0

		flip = create_tween()
		flip.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).tween_property(self, "rotation_t", 1.0, 0.3).set_delay(0.1)

		var bounce := create_tween()
		var parallel_a = bounce.parallel()
		var parallel_b = bounce.parallel()

		parallel_a.set_ease(Tween.EASE_OUT).tween_property(offset, "position", Vector3(0, 0.7, 0), 0.15)
		parallel_a.parallel().set_ease(Tween.EASE_OUT).tween_property(anchor, "scale", Vector3(0.9, 1.3, 0.9), 0.15)
		parallel_a.chain().set_ease(Tween.EASE_IN).tween_property(offset, "position", Vector3.ZERO, 0.1)
		parallel_b.set_ease(Tween.EASE_OUT).tween_property(anchor, "scale", Vector3(1.25, 0.9, 1.25), 0.1)
		parallel_b.chain().set_ease(Tween.EASE_IN).tween_property(anchor, "scale", Vector3.ONE, 0.1)


		# Wait for the tween here, just where we did anything with it.
		# Nobody else needs to know and check it, because this function owns it.
		await flip.finished
	else:
		# TODO: can't move there, play blocked anim
		pass
