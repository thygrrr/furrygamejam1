class_name FadeOverlay
extends ColorRect

@export var fade_in_duration: float = 2.0
@export var fade_out_duration: float = 2.0
@export var auto_fade_in: bool = true
@export var minimum_opacity: float = 1.0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	modulate.a = minimum_opacity
	if auto_fade_in:
		fade_in()

func fade_in():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate", Color(modulate, 0.0), fade_in_duration)
	await tween.finished

func fade_out():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate", Color(modulate, minimum_opacity), fade_out_duration)
	await tween.finished
