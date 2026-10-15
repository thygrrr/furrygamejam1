extends Control
class_name Cutscene

func _ready():
	visible = false
	for child in get_children():
		if child is Cutscene:
			child.visible = false
			child.scale = Vector2.ZERO


func play() -> void:
	visible = true
	if get_parent() is Cutscene:
		scale = Vector2.ZERO
		if await Tweens.play(self, Tweens.control_scale(Vector2.ONE, 0.5, Tweens.Ease.BACK_OUT)).end != Tweens.Reason.COMPLETED:
			return

	for child in get_children():
		if child is Cutscene:
			await child.play()

	if get_parent() is Cutscene:
		await seconds(2)

	if get_parent() is Cutscene:
		Tweens.play(self, Tweens.control_scale(Vector2.ZERO, 0.5, Tweens.Ease.BACK_IN, 2.0))



func seconds(amount: float):
	await get_tree().create_timer(amount).timeout
