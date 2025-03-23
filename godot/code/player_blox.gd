extends Player
class_name PlayerBlox


func debug_faces(other: Node3D):
	if other:
		prints("Blox faces", other)


func _ready() -> void:
	super()
	faces.connect(debug_faces)


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

	if obstacle is Critter and obstacle.can_move(next_pos + next_step):
		Grid.write(curr_pos, null)
		var crit = (obstacle as Critter)
		crit.move_to(next_pos + next_step, next_flip)
		await get_tree().create_timer(0.05).timeout
		await move_to(next_pos, next_flip)
	else:
		pass # play collision fx

	get_tree().call_group("critters", "update_facing")
