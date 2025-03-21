extends Interactable
class_name Critter

@onready var anchor : Node3D = %anchor
@onready var offset : Node3D = %offset
@onready var view : Node3D = %view

@onready var voice : AudioStreamPlayer3D = $voice


var from_rotation := Quaternion.IDENTITY
var goal_rotation := Quaternion.IDENTITY

var rotation_t : float = 1.0

var flip_left := Quaternion(Vector3.BACK, deg_to_rad(90))
var flip_right := Quaternion(Vector3.FORWARD, deg_to_rad(90))
var flip_up := Quaternion(Vector3.LEFT, deg_to_rad(90))
var flip_down := Quaternion(Vector3.RIGHT, deg_to_rad(90))

var flip : Tween

signal moved(direction: Vector3)
signal faces(whom: Critter)

func _ready() -> void:
	super()

func _move_sound() -> void:
	$AudioStreamPlayer3D.play()

func _in_view_space(rot : Quaternion):
	return view.quaternion.inverse() * rot * view.quaternion

func move_to(destination: Vector3, next_flip : Quaternion):
	if Grid.write(destination, self):
		_move_sound()

		Grid.clear(global_position)
		global_position = destination

		from_rotation = goal_rotation
		goal_rotation *= _in_view_space(next_flip)

		rotation_t = 0.0

		flip = create_tween()
		flip.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).tween_property(self, "rotation_t", 1.0, 0.2).set_delay(0.05)

		var bounce := create_tween()
		var parallel_a = bounce.parallel()
		var parallel_b = bounce.parallel()

		parallel_a.set_ease(Tween.EASE_OUT).tween_property(offset, "position", Vector3(0, 0.7, 0), 0.1)
		parallel_a.parallel().set_ease(Tween.EASE_OUT).tween_property(anchor, "scale", Vector3(0.9, 1.3, 0.9), 0.1)
		parallel_a.chain().set_ease(Tween.EASE_IN).tween_property(offset, "position", Vector3.ZERO, 0.05)
		parallel_b.set_ease(Tween.EASE_OUT).tween_property(anchor, "scale", Vector3(1.25, 0.9, 1.25), 0.05)
		parallel_b.chain().set_ease(Tween.EASE_IN).tween_property(anchor, "scale", Vector3.ONE, 0.1)

		# Wait for the tween here, just where we did anything with it.
		# Nobody else needs to know and check it, because this function owns it.
		await flip.finished

		moved.emit()

		if is_vertical():
			faces.emit(null)
		else:
			var node = Grid.read(global_position + view.global_basis.z)
			if node:
				faces.emit(node)


func is_vertical():
	return is_up() or is_down()

func is_up():
	return Vector3.UP.dot(view.global_basis.z) > 0.9

func is_down():
	return Vector3.DOWN.dot(view.global_basis.z) > 0.9
