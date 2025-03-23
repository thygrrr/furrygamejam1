extends Control
class_name Cutscene

func _ready():
	visible = false
	for child in get_children():
		if child is Cutscene:
			child.visible = false

func play() -> void:
	scale = Vector2.ZERO
	visible = true
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2.ONE, 0.5)

	for child in get_children():
		if child is Cutscene:
			await child.play()

	await seconds(1)

	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	await tween


func seconds(amount: float):
	await get_tree().create_timer(amount).timeout
