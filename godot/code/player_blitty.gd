extends Player
class_name PlayerBlitty


func debug_faces(other: Node3D):
	if other:
		prints("Blitty faces", other)

func debug_sees(other: Node3D):
	if other:
		prints("Blitty sees", other)


func _ready() -> void:
	super()
	faces.connect(debug_faces)
	sees.connect(debug_sees)


# Resolve a single input event
func execute(event: InputEvent) -> void:
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

	var next_pos = global_position + next_step
	var curr_pos = global_position

	var obstacle = Grid.read(next_pos)
	if not obstacle:
		Grid.write(curr_pos, null)
		await move_to(next_pos, next_flip)


	if obstacle is Critter:
		Grid.write(curr_pos, null)
		var crit = (obstacle as Critter)
		crit.move_to(global_position, next_flip.inverse())
		await get_tree().create_timer(0.05).timeout
		await move_to(next_pos, next_flip)
	else:
		pass # play collision fx

	get_tree().call_group("critters", "update_facing")
