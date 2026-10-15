extends Interactable
class_name Critter

var material = preload("res://characters/mat_impact.tres")

@onready var anchor : Node3D = %anchor
@onready var offset : Node3D = %offset

@onready var voice : AudioStreamPlayer3D = $voice

var from_rotation := Quaternion.IDENTITY
var goal_rotation := Quaternion.IDENTITY

var rotation_t : float = 1.0

var flip_left := Quaternion(Vector3.BACK, deg_to_rad(90))
var flip_right := Quaternion(Vector3.FORWARD, deg_to_rad(90))
var flip_up := Quaternion(Vector3.LEFT, deg_to_rad(90))
var flip_down := Quaternion(Vector3.RIGHT, deg_to_rad(90))

var flip : TweensGdHandle

signal moved(direction: Vector3)
signal faces(whom: Critter)
signal sees(whom: Critter)
signal process

func _ready() -> void:
	super()
	var old_quaternion := quaternion
	quaternion = Quaternion.IDENTITY
	anchor.top_level = true
	goal_rotation = old_quaternion
	from_rotation = goal_rotation
	view.quaternion = goal_rotation
	$anchor/Particles.emitting = true



# Smoothly LERP position (TODO: use SmoothRemoteTransform to do this work)
func _process(_delta : float) -> void:
	var k := pow(0.9, _delta * 120.0)
	anchor.global_position = k * anchor.global_position + (1-k) * global_position

	view.quaternion = from_rotation.slerp(goal_rotation, rotation_t)
	process.emit()



func _move_sound() -> void:
	$MoveSound.play(0.05)

func _flop_sound() -> void:
	$FlopSound.play()

func _pop_sound() -> void:
	$PopSound.play()

func _block_sound() -> void:
	$BlockSound.play()

func _in_view_space(rot : Quaternion) -> Quaternion:
	return view.quaternion.inverse() * rot * view.quaternion

func can_move(destination: Vector3) -> bool:
	return Grid.read(destination) == null


func move_to(destination: Vector3, next_flip : Quaternion):
	_pop_sound()
	_move_sound()

	Grid.write(destination, self)

	global_position = destination

	from_rotation = goal_rotation
	goal_rotation *= _in_view_space(next_flip)

	rotation_t = 0.0

	flip = Tweens.play(self, Tweens.property(^"rotation_t", 1.0, 0.2, Tweens.Ease.CUBIC_OUT, 0.05))
	_bounce()

	await get_tree().create_timer(0.15).timeout
	_flop_sound()
	if self is Player: # hack, ain't got time for this
		Camera.shake = 0.5
	$anchor/Particles.emitting = true

	if await flip.end == Tweens.Reason.COMPLETED:
		moved.emit()


# Both original parallel variables aliased one Tween: lift/stretch, fall,
# squash, restore. Its default transition was LINEAR throughout.
# Start the fixed timeline together so frame hitches preserve its timing.
func _bounce() -> TweensGdGroup:
	var lift := Vector3(0, 0.7, 0)
	var stretch := Vector3(0.9, 1.3, 0.9)
	var squash := Vector3(1.25, 0.9, 1.25)
	return Tweens.group([
		Tweens.play(offset, Tweens.position_3d(lift, 0.15)),
		Tweens.play(anchor, Tweens.scale_3d(stretch, 0.1)),
		Tweens.play(offset, Tweens.position_3d(Vector3.ZERO, 0.05).with_delay(0.15).with_from(lift)),
		Tweens.play(anchor, Tweens.scale_3d(squash, 0.05).with_delay(0.2).with_from(stretch)),
		Tweens.play(anchor, Tweens.scale_3d(Vector3.ONE, 0.1).with_delay(0.25).with_from(squash)),
	])


func update_facing():
	var node = Grid.read(global_position + view.global_basis.z)
	if node == self:
		return

	if node is Interactable and not is_vertical():
		sees.emit(node)
		if node.omni or node.view.global_basis.z.dot(view.global_basis.z) < -0.7:
			if node.view.global_basis.y.dot(view.global_basis.y) > 0.7:
				faces.emit(node)
	else:
		faces.emit(null)
		sees.emit(null)


func is_vertical():
	return is_up() or is_down()

func is_up():
	return Vector3.UP.dot(view.global_basis.z) > 0.9

func is_down():
	return Vector3.DOWN.dot(view.global_basis.z) > 0.9
